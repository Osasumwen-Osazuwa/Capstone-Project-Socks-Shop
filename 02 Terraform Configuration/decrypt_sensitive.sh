#!/bin/bash 

# Decrypt the sensitive.tfvars file using Ansible Vault
decrypt_sensitive() {
    # Prompt the user for the Ansible Vault password
    echo -n "Enter Ansible Vault password: "
    read -s VAULT_PASSWORD

    # Decrypt the sensitive.tfvars file using Ansible Vault
    ansible-vault decrypt sensitive.tfvars --output=- --vault-password-file=vault_password.vault
}

# Capture the decrypted variables
decrypted_variables=$(decrypt_sensitive)

# Check if decryption was successful
if [ $? -eq 0 ]; then
    # Pass decrypted variables to Terraform as environment variables
    export $(echo "$decrypted_variables" | grep -v '^$' | xargs)
    echo "Decrypted variables set as environment variables."
else
    echo "Failed to decrypt sensitive.tfvars file. Please check the Ansible Vault password."
    exit 1
fi

