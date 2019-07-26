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
