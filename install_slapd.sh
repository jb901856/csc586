#!/bin/bash

#By Jeff Bowker
#csc586 Assignment 2
#This program will create the slapd database on a node

#update ubuntu
sudo apt-get update

#set in interactive mode
export DEBIAN_FRONTEND=noninteractive

#set the debconf-set-selections
echo -e "slapd slapd/root_password password 123" | sudo debconf-set-selections
echo -e "slapd slapd/root_password_again password 123" | sudo debconf-set-selections
echo -e "slapd slapd/internal/adminpw password 123" | sudo debconf-set-selections
echo -e "slapd slapd/internal/generated_adminpw password 123" | sudo debconf-set-selections
echo -e "slapd slapd/password2 password 123" | sudo debconf-set-selections
echo -e "slapd slapd/password1 password 123" | sudo debconf-set-selections
echo -e "slapd slapd/domain string clemson.cloudlab.us" | sudo debconf-set-selections
echo -e "slapd slapd/move_old_databse boolean true" | sudo debconf-set-selections
echo -e "slapd shared/organization string nodomain" | sudo debconf-set-selections
echo -e "slapd slapd/purge_database boolean false" | sudo debconf-set-selections
echo -e "slapd slapd/no_configuration boolean false" | sudo debconf-set-selections
echo -e "slapd slapd/backend select MDB" | sudo debconf-set-selections

#install the slapd
sudo apt-get install ldap-utils slapd -q -y

#reconfigure slapd
sudo dpkg-reconfigure slapd

#set ssopassword for the student account
ssopass=$(slappasswd -s rammy)

#add the new password to the users.ldif files
cat <<EOF > /local/repository/users.ldif
dn: uid=student,ou=People,dc=clemson,dc=cloudlab,dc=us
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: student
sn: Ram
givenName: Golden
cn: student
displayName: student
uidNumber: 10000
gidNumber: 5000
userPassword: $ssopass
gecos: Golden Ram
loginShell: /bin/dash
homeDirectory: /home/student
EOF

#allow the firewall
sudo ufw allow ldap

#add in the slapd repositories
ldapadd -f /local/repository/basedn.ldif -x -D "cn=admin,dc=clemson,dc=cloudlab,dc=us" -w 123

ldapadd -f /local/repository/users.ldif -x -D "cn=admin,dc=clemson,dc=cloudlab,dc=us" -w 123
