## to do: change FQDN stuff (greyranger) to parameter - ideally $1
## 1st parameter is the fqdn
## 2nd parameter is the domain

sudo hostnamectl set-hostname $1
sudo apt-get update -y
# sudo apt-get upgrade -y

#### set response for post fix install ###
sudo debconf-set-selections <<< "postfix postfix/mailname string '$1'"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get -y install postfix
sudo ufw allow 25/tcp
sudo apt-get install mailutils -y
echo "address { email-domain swayseasttest.xyz;};" > /etc/mailutils.conf
sudo systemctl restart postfix


## open ports for http, https, authenticated smtp, ssl smtp, imap, imap ssl
sudo ufw allow 80,443,587,465,143,993/tcp

sudo apt install software-properties-common -y
curl -o- https://raw.githubusercontent.com/vinyll/certbot-install/master/install.sh | bash
sudo apt install python3-certbot-nginx -y


## configure nginx
echo "server {
      		listen 80;
      		listen [::]:80;
      		server_name $1;

      		root /var/www/$1/;

      		location ~ /.well-known/acme-challenge {
         		allow all;
      		}
	}" > /etc/nginx/conf.d/$1.conf

sudo mkdir /var/www/$1
sudo chown www-data:www-data /var/www/$1 -R
sudo systemctl reload nginx
sudo certbot --nginx --agree-tos --redirect --hsts --staple-ocsp --register-unsafely-without-email -d $1

## append submission to master.cf
# echo "submission     inet     n    -    y    -    -    smtpd
# 	 -o syslog_name=postfix/submission
# 	 -o smtpd_tls_security_level=encrypt
# 	 -o smtpd_tls_wrappermode=no
# 	 -o smtpd_sasl_auth_enable=yes
# 	 -o smtpd_relay_restrictions=permit_sasl_authenticated,reject
# 	 -o smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject
# 	 -o smtpd_sasl_type=dovecot
# 	 -o smtpd_sasl_path=private/auth

# 	smtps     inet  n       -       y       -       -       smtpd
# 	  -o syslog_name=postfix/smtps
# 	  -o smtpd_tls_wrappermode=yes
# 	  -o smtpd_sasl_auth_enable=yes
# 	  -o smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject
# 	  -o smtpd_sasl_type=dovecot
# 	  -o smtpd_sasl_path=private/auth" >> /etc/postfix/master.cf


