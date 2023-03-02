NC='\033[0m'

Black='\033[0;30m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
Purple='\033[0;35m'
Cyan='\033[0;36m'
White='\033[0;37m'

################################################################################################
# GENERATE
################################################################################################
echo -e "${Green}Generate a new private key and csr${NC}"
echo "openssl req  -nodes -sha256 -newkey rsa:2048 -keyout server.key -out server.csr"
echo "openssl req -out server.csr -pubkey -new -keyout server.key"
echo
echo
echo -e "${Green}Generate a csr for an existing private key${NC}"
echo "openssl req -out server.csr -key server.key -new"
echo
echo
echo -e "${Green}Generate a csr based on an existing certificate${NC}"
echo "openssl x509 -x509toreq -in server.crt -out server.csr -signkey server.key"
echo
echo
echo -e "${Green}Generate self-signed certificate${NC}"
echo "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout server.key -out server.crt"
echo
echo
echo -e "${Green}Remove password from a private key${NC}"
echo "openssl rsa -in privateKey.pem -out newPrivateKey.pem"
echo
echo
################################################################################################
# CHECK
################################################################################################
echo -e "${Green}Check csr${NC}"
echo "openssl req -text -noout -verify -in server.csr"
echo
echo
echo -e "${Green}Check private key${NC}"
echo "openssl rsa -in server.key -check"
echo
echo
echo -e "${Green}Check certificate${NC}"
echo "openssl x509 -in server.crt -text -noout"
echo
echo
echo -e "${Green}Check PKCS#12${NC}" 
echo "openssl pkcs12 -info -in keyStore.p12"
echo
echo
echo -e "${Green}Check MD5 public key to check against CSR or private key${NC}"
echo "openssl x509 -noout -modulus -in server.crt | openssl md5"
echo "openssl rsa -noout -modulus -in server.key | openssl md5"
echo "openssl req -noout -modulus -in server.csr | openssl md5"
echo -e "${Green}Check SSL connection${NC}"
echo"openssl s_client -connect www.example.com:443"
echo
echo
################################################################################################
# CONVERT
################################################################################################
echo -e "${Green}Convert DER file to PEM${NC}"
echo "openssl x509 -inform der -in certificate.cer -out certificate.pem"
echo
echo
echo -e "${Green}Convert PEM file to DER${NC}"
echo "openssl x509 -outform der -in certificate.pem -out certificate.der"
echo
echo
echo -e "${Green}Convert PKCS#12 to PEM${NC}"
echo "openssl pkcs12 -in server.pfx -out server.pem -nodes"
echo
echo
echo -e "${Green}Convert PEM certificate file and a private key to PKCS#12${NC}"
echo "openssl pkcs12 -export -out server.pfx -inkey server.key -in server.crt -certfile CACert.crt"
echo
echo
