sudo su
cd
export DEBIAN_FRONTEND=noninteractive

echo -e "slapd slapd/root_password password 123" |debconf-set-selections
echo -e "slapd slapd/root_password_again password 123" |debconf-set-selections
echo -e "slapd slapd/internal/adminpw password 123" |debconf-set-selections
echo -e "slapd slapd/internal/generated_adminpw password 123" |debconf-set-selections
echo -e "slapd slapd/password2 password 123" |debconf-set-selections
echo -e "slapd slapd/password1 password 123" |debconf-set-selections

apt-get install ldap-utils slapd -y

dpkg-reconfigure slapd

ufw allow ldap

ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -W -f basedn.ldif


ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -W -F users.ldif

cd clnodevm109-1.clemson.cloudlab.us

sudo apt-get update

sudo apt install -y libnss-ldap libpam-ldap ldap-utils

