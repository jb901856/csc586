#!/bin/bash
#log into ldapserver

sudo apt-get update
sudo apt-get install debconf-utils

sudo export DEBIAN_FRONTEND='non-interactive'
echo -e "slapd slapd/root_password password 123" |debconf-set-selections
echo -e "slapd slapd/root_password_again password 123" |debconf-set-selections
echo -e "slapd slapd/internal/adminpw password 123" |debconf-set-selections
echo -e "slapd slapd/internal/generated_adminpw password 123" |debconf-set-selections
echo -e "slapd slapd/password2 password 123" |debconf-set-selections
echo -e "slapd slapd/password1 password 123" |debconf-set-selections
echo -e "slapd slapd/domain string clemson.cloudlab.us" |debconf-set-selections
echo -e "slapd slapd/move_old_databse boolean true" |debconf-set-selections
echo -e "slapd shared/organization string nodomain" |debconf-set-selections
echo -e "slapd slapd/purge_database boolean false" |debconf-set-selections
echo -e "slapd slapd/no_configuration boolean false" |debconf-set-selections
echo -e "slapd slapd/backend select MDB" |debconf-set-selections

 apt-get install -y slapd ldap-utils

sudo dpkg-reconfigure slapd

sudo ufw allow ldap

sudo chmod 755 basedn.ldif
sudo ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -W -f basedn.ldif

sudo chmod 755 users.ldif
sudo ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -W -F users.ldif
