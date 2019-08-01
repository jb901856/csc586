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

stu_pwd="rammy"
ssopass=$(slappasswd -s $stu_pwd)

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

sudo ufw allow ldap

sudo chmod 755 basedn.ldif
ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -w 123 -f basedn.ldif

sudo chmod 755 users.ldif
ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -w 123 -f users.ldif
