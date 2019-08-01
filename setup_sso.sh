#!/bin/bash

#By Jeff Bowker
#csc586 Assignment 2
#log into ldapclient

sudo apt-get update

export DEBIAN_FRONTEND=noninteractive
echo -e " \
libnss-ldap libnss-ldap/dblogin boolean false
libnss-ldap shared/ldapns/base-dn   string  dc=clemson,dc=cloudlab,dc=us
libnss-ldap libnss-ldap/binddn  string  cn=proxyuser,dc=clemson,dc=us
libnss-ldap libnss-ldap/dbrootlogin boolean true
libnss-ldap libnss-ldap/override    boolean true
libnss-ldap shared/ldapns/ldap-server   string  ldap://192.168.1.1
libnss-ldap libnss-ldap/confperm    boolean false
libnss-ldap libnss-ldap/rootbinddn  string  cn=admin,dc=example,dc=com
libnss-ldap shared/ldapns/ldap_version  select  3
libnss-ldap libnss-ldap/nsswitch    note    \
" | sudo debconf-set-selections

sudo apt install -y -q libnss-ldap -y libpam-ldap ldap-utils

sudo sed -i 's/uri ldapi:\/\/\//uri ldap:\/\/192.168.1.1\//g' /etc/ldap.conf
sudo sed -i 's/base dc=example,dc=net/base dc=clemson,dc=cloudlab,dc=us/g' /etc/ldap.conf
sudo sed -i 's/rootbinddn cn=manager,dc=example,dc=net/rootbinddn cn=admin,dc=clemson,dc=cloudlab,dc=us/g' /etc/ldap.conf
sudo sed -i '/passwd:/ s/$/ ldap/' /etc/nsswitch.conf
sudo sed -i '/group:/ s/$/ ldap/' /etc/nsswitch.conf
sudo sed -i '/# end of pam-auth-update config/ i session optional pam_mkhomedir.so  skel=/etc/skel  umsak=077' /etc/pam.d/common-session
sudo sed -i 's/use_authtok//g' /etc/pam.d/common-password
sudo bash <<EOF
echo 123 > /etc/ldap.secret
EOF
sudo chmod 600 /etc/ldap.secret

#fetches and prints details for a particular user 
getent passwd student
