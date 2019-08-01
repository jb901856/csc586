#!/bin/bash

#By Jeff Bowker
#csc586 Assignment 2
#log into ldapserver

sudo apt-get update

export DEBIAN_FRONTEND=noninteractive

echo -e "slapd slapd/root_password password 123" |sudo debconf-set-selections
echo -e "slapd slapd/root_password_again password 123" |sudo debconf-set-selections
echo -e "slapd slapd/internal/adminpw password 123" |sudo debconf-set-selections
echo -e "slapd slapd/internal/generated_adminpw password 123" |sudo debconf-set-selections
echo -e "slapd slapd/password2 password 123" |sudo debconf-set-selections
echo -e "slapd slapd/password1 password 123" |sudo debconf-set-selections
echo -e "slapd slapd/domain string clemson.cloudlab.us" |sudo debconf-set-selections
echo -e "slapd slapd/move_old_databse boolean true" |sudo debconf-set-selections
echo -e "slapd shared/organization string nodomain" |sudo debconf-set-selections
echo -e "slapd slapd/purge_database boolean false" |sudo debconf-set-selections
echo -e "slapd slapd/no_configuration boolean false" |sudo debconf-set-selections
echo -e "slapd slapd/backend select MDB" |sudo debconf-set-selections

sudo apt-get install ldap-utils slapd -q -y

sudo dpkg-reconfigure slapd

sudo ufw allow ldap

sudo chmod 755 basedn.ldif
ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -w 123 -f basedn.ldif

sudo chmod 755 users.ldif
ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -w 123 -f users.ldif
