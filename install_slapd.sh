#!/bin/bash
#log into ldapserver

sudo apt-get update

sudo echo -e "slapd slapd/root_password password 123" |debconf-set-selections
sudo echo -e "slapd slapd/root_password_again password 123" |debconf-set-selections
sudo echo -e "slapd slapd/internal/adminpw password 123" |debconf-set-selections
sudo echo -e "slapd slapd/internal/generated_adminpw password 123" |debconf-set-selections
sudo echo -e "slapd slapd/password2 password 123" |debconf-set-selections
sudo echo -e "slapd slapd/password1 password 123" |debconf-set-selections
sudo echo -e "slapd slapd/domain string clemson.cloudlab.us" |debconf-set-selections
sudo echo -e "slapd slapd/move_old_databse boolean true" |debconf-set-selections
sudo echo -e "slapd shared/organization string nodomain" |debconf-set-selections
sudo echo -e "slapd slapd/purge_database boolean false" |debconf-set-selections
sudo echo -e "slapd slapd/no_configuration boolean false" |debconf-set-selections
sudo echo -e "slapd slapd/backend select MDB" |debconf-set-selctions

sudo export DEBIAN_FRONTEND=noninteractive apt-get install -y slapd ldap-utils

sudo dpkg-reconfigure slapd

sudo ufw allow ldap

sudo ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -W -f basedn.ldif

sudo ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -W -F users.ldif
