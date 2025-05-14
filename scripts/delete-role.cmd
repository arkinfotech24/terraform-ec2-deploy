@echo off
set ROLE_NAME=SSM-EC2Role

aws iam get-role --role-name %ROLE_NAME% >nul 2>&1
if %ERRORLEVEL% EQU 0 (
  echo ⚠️ Role %ROLE_NAME% exists. Deleting before Terraform Apply...
  aws iam detach-role-policy --role-name %ROLE_NAME% --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
  aws iam delete-role --role-name %ROLE_NAME%
) else (
  echo ✅ Role %ROLE_NAME% not found. Continuing...
)
