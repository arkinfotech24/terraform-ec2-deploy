#!/bin/bash
ROLE_NAME="SSM-EC2Role"

if aws iam get-role --role-name "$ROLE_NAME" > /dev/null 2>&1; then
  echo "⚠️ Role $ROLE_NAME exists. Deleting before Terraform Apply..."
  aws iam detach-role-policy --role-name "$ROLE_NAME" --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore || true
  aws iam delete-role --role-name "$ROLE_NAME"
else
  echo "✅ Role $ROLE_NAME not found. Continuing..."
fi
