"""
Rotates a secret in Azure Key Vault and logs the rotation event.

Usage:
    python rotate-keyvault-secret.py --vault-name secure-deploy-kv --secret-name db-connection-string
"""

import argparse
import secrets
import string
from datetime import datetime, timezone

from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient


def generate_secret(length: int = 32) -> str:
    alphabet = string.ascii_letters + string.digits
    return "".join(secrets.choice(alphabet) for _ in range(length))


def rotate_secret(vault_name: str, secret_name: str) -> None:
    vault_url = f"https://{vault_name}.vault.azure.net"
    credential = DefaultAzureCredential()
    client = SecretClient(vault_url=vault_url, credential=credential)

    new_value = generate_secret()
    client.set_secret(secret_name, new_value)

    print(f"[{datetime.now(timezone.utc).isoformat()}] Rotated secret "
          f"'{secret_name}' in vault '{vault_name}'.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--vault-name", required=True)
    parser.add_argument("--secret-name", required=True)
    args = parser.parse_args()

    rotate_secret(args.vault_name, args.secret_name)
