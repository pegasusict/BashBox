!/bin/env bash


# fun: rsa_generate_keys
# txt: generates 4096 bits key-pair
# use: rsa_generate_keys KEY_FILE
# opt: str KEY_FILE: filename for key-file
# api: rsa
rsa_generate_keys(){
    KEY_FILE="$1"
    openssl genrsa -des3 -out ${KEY_FILE}.pem 4096
}
# fun: rsa_export_pubkey
# txt: exports public-key
# use: rsa_export_pubkey PRIVATE_KEY_FILE PUBLIC_KEY_FILE
# opt: str PRIVATE_KEY_FILE: filename of private_key-file from which the public key needs to be extracted.
# opt: str PUBLIC_KEY_FILE: filename of public_key-file to which the public key needs to be extracted.
# api: rsa
rsa_export_pubkey(){
    PRIVATE_KEY_FILE="$1"
    PUBLIC_KEY_FILE="$2"
    openssl rsa -in ${PRIVATE_KEY_FILE}.pem -outform PEM -pubout -out ${PUBLIC_KEY_FILE}.pem
}
# fun: rsa_export_privkey
# txt: exports private-key unencrypted.     USE WITH CAUTION!!!!!!!!!!
# use: rsa_export_privkey PRIVATE_KEY_FILE_ENCRYPTED PRIVATE_KEY_FILE_UNENCRYPTED
# opt: str PRIVATE_KEY_FILE_ENCRYPTED: filename of private_key-file from which the private key needs to be extracted.
# opt: str PRIVATE_KEY_FILE_UNENCRYPTED: filename of private_key-file to which the private key needs to be extracted.
# api: rsa
rsa_export_privkey(){
    PRIVATE_KEY_FILE_ENCRYPTED="$1"
    PRIVATE_KEY_FILE_UNENCRYPTED="$2"
    openssl rsa -in ${PRIVATE_KEY_FILE_ENCRYPTED}.pem -out ${PRIVATE_KEY_FILE_UNENCRYPTED}.pem -outform PEM
}
