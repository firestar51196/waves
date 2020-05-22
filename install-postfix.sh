sudo hostnamectl set-hostname greyranger.swayseasttest.xyz
sudo apt-get update -y
sudo apt-get upgrade -y

#### set response for post fix install ###
sudo debconf-set-selections <<< "postfix postfix/mailname string 'greyranger.swayseasttest.xyz'"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get -y install postfix
sudo ufw allow 25/tcp

sudo systemctl restart postfix

## open ports for http, https, authenticated smtp, ssl smtp, imap, imap ssl
sudo ufw allow 80,443,587,465,143,993/tcp

sudo apt install software-properties-common
curl -o- https://raw.githubusercontent.com/vinyll/certbot-install/master/install.sh | bash
sudo apt install python3-certbot-nginx

