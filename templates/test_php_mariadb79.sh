#!/bin/bash
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo docker-compose --version
sudo mkdir -p /var/www/html && sudo mkdir -p /var/www/vault && sudo chmod 777 -R /var/www/
sudo cat << 'EOT' > /var/www/html/index.php
<html>
    <head>
        <title>Hello 2024!</title>
    </head>

    <body>

    <h1>Hello 2024!</h1>
    Attempting MariaDB connection from php...</br>
        <?php
            $vlt_url        = getenv('VAULT_ADDR');
            $vlt_path       = getenv('VAULT_PATH');
            $host           = getenv('DB_HOST');
            $dbname         = getenv('DB_NAME');
            if (file_exists("/var/www/secrets.json")) {
              $secrets_json = file_get_contents("/var/www/secrets.json", "r");
              $user = json_decode($secrets_json)->{'username'};
              $pass = json_decode($secrets_json)->{'password'};
            }
            else{
              echo "Secrets not found.";
              exit;
            }
            // Get vault-token
            if (file_exists("/var/www/.vault-token")) {
              $token = file_get_contents("/var/www/.vault-token", "r");
            }
            else{
              echo "Token not found.";
              exit;
            }

            echo "Using database user: <b>".$user."</b></br>";

            // Create connection
            $conn = new mysqli($host, $user, $pass, $dbname);

            // Check connection
            if ($conn->connect_error) {
                die("Connection failed: " . $conn->connect_error);
            }
            else {
                echo "Connected successfully.</br>";
            }
            echo "</br>Data test into DB:<br>";
            if (!$conn->query("DROP TABLE IF EXISTS test") ||
                !$conn->query("CREATE TABLE test(id INT, value VARCHAR(255))") ) {
                echo "Fail to create table: (" . $conn->errno . ") " . $conn->error;
            }

            echo "Encrypt value from Vault...</br>";
            $ch = curl_init();

            curl_setopt($ch, CURLOPT_URL, $vlt_url . "/v1/transit/encrypt/web");
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, '{"plaintext":"' . base64_encode($_SERVER['SERVER_NAME']) . '"}');
            curl_setopt($ch, CURLOPT_HTTPHEADER, array(
               'X-Vault-Token: '.$token
            ));
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            $result = curl_exec($ch);#echo "$result </br/>";

            curl_close($ch);

            $cipher_value = json_decode($result)->{'data'}->{'ciphertext'};
            echo "Encrypted value from Vault:" . $cipher_value . "</br>";

            echo "Put data into database...</br>";

            if (!$conn->query('INSERT INTO test(id, value) VALUES (1,"Hello"), (2,"World!"), (3,"' . $cipher_value . '")')) {
                echo "Fail to insert into table: (" . $conn->errno . ") " . $conn->error;
            }

            echo "Get data from database:</br>";

            if(! $res = $conn->query("SELECT id, value FROM test ORDER BY id ASC")) {
                echo "Fail to select ids in table: (" . $conn->errno . ") " . $conn->error;
            }

            for ($row_no = $res->num_rows - 1; $row_no >= 0; $row_no--) {
                $res->data_seek($row_no);
                $row = $res->fetch_assoc();
                echo " id = " . $row['id'] . " & value = " . $row['value'] . "</br>";
            }
            ?>
    </body>
</html>
EOT
sudo cat << 'EOT' > /var/www/vault/config.hcl
pid_file = "./pidfile"

auto_auth {
  method "approle" {
    config = {
      role_id_file_path = "/root/role-id"
      secret_id_file_path = "/root/.secret-id"
      remove_secret_id_file_after_reading = true
    }
  }

  sink "file" {
    config = {
      path = "/var/www/.vault-token"
      mode = 0644
    }
  }
}

template_config {
  exit_on_retry_failure = true
  max_connections_per_host = 20
}

template {
  source = "/var/www/secrets.tpl"
  destination = "/var/www/secrets.json"
  error_on_missing_key = true
}

EOT

sudo cat << 'EOT' > /var/www/vault/secrets.tpl
{
  {{ with secret (env "VAULT_PATH") }}
  "username":"{{ .Data.data.username }}",
  "password":"{{ .Data.data.password }}"
  {{ end }}
}
EOT

sudo cat << 'EOT' > /var/www/vault/entrypoint.sh
#! /bin/bash

echo "$VLT_ROLE_ID" >> /root/role-id
echo "$VLT_SECRET_ID" >> /root/.secret-id


vault agent -config=/root/config.hcl &
apache2-foreground

EOT
VAULT_VERSION="1.11.2"
sudo cat << 'EOT' > /var/www/Dockerfile
FROM php:7.4-apache
ARG VAULT_VERSION=1.11.2
RUN a2enmod rewrite

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN apt-get update && apt-get install -y jq wget unzip curl tar
RUN wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && unzip -d /bin vault_${VAULT_VERSION}_linux_amd64.zip

COPY vault/config.hcl /root/config.hcl
COPY vault/entrypoint.sh /usr/local/bin
COPY vault/secrets.tpl /var/www/secrets.tpl
EOT
sudo cat << 'EOT' > /var/www/docker-compose.yml
version: '3.8'
services:
    web:
        container_name: web-mariadb-apache
        entrypoint: ["entrypoint.sh"]
        build:
            context: ./
            dockerfile: Dockerfile
        depends_on:
            - db
        volumes:
            - ./html/:/var/www/html/
        environment:
            - VLT_ROLE_ID=f265e87f-41c5-096e-e154-a5129d294e53
            - VLT_SECRET_ID=e9cb7e0e-e233-5cbc-6e24-1a6abb92ec87
            - DB_HOST=db
            - DB_NAME=testlab_mariadb
            - VAULT_ADDR=https://vault.lumigame.com
            - VAULT_PATH=kv/lumi/database/mariadb/dbtest
        ports:
            - 9000:80

    db:
        container_name: mariadb
        image: mariadb
        restart: always
        environment:
            MYSQL_ROOT_PASSWORD: maria987
            MYSQL_DATABASE: testlab_mariadb
            MYSQL_USER: vaultuser_mariadb
            MYSQL_PASSWORD: pass12345mariadb
        ports:
            - "3306:3306"
EOT

cd /var/www/ && sudo docker rm -v -f $(sudo docker ps -qa) 
sudo docker-compose build && sudo docker-compose up -d
