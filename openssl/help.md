Generate a new private key and csr
```
openssl req  -nodes -sha256 -newkey rsa:2048 -keyout server.key -out server.csr
openssl req -out server.csr -pubkey -new -keyout server.key
```

Generate a csr for an existing private key
```
openssl req -out server.csr -key server.key -new
```

Generate a csr based on an existing certificate
```
openssl x509 -x509toreq -in server.crt -out server.csr -signkey server.key
```

Generate self-signed certificate
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout server.key -out server.crt
```

Remove password from a private key
```
openssl rsa -in server.pem -out newserver.pem
```

Check csr
```
openssl req -text -noout -verify -in server.csr
```

Check private key
```
openssl rsa -in server.key -check
```

Check certificate
```
openssl x509 -in server.crt -text -noout
```

Check PKCS#12
```
openssl pkcs12 -info -in keyStore.p12
```

Check MD5 public key to check against CSR or private key
```
openssl x509 -noout -modulus -in server.crt | openssl md5
openssl rsa -noout -modulus -in server.key | openssl md5
openssl req -noout -modulus -in server.csr | openssl md5
```
Check SSL connection
```
openssl s_client -connect www.example.com:443
```

Convert DER file to PEM
```
openssl x509 -inform der -in certificate.cer -out certificate.pem
```

Convert PEM file to DER
```
openssl x509 -outform der -in certificate.pem -out certificate.der
```

Convert PKCS#12 to PEM
```
openssl pkcs12 -in server.pfx -out server.pem -nodes
```

Convert PEM certificate file and a private key to PKCS#12
```
openssl pkcs12 -export -out server.pfx -inkey server.key -in server.crt -certfile CACert.crt
```
