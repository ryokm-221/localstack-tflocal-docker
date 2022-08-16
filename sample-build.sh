#!/bin/bash -e
cwd="$(pwd)"
rm -f terraform/lambda_func.zip
zip "terraform/lambda_func.zip" node_modules/ index.js package.json package-lock.json
cd terraform && docker run --rm -it -v "$(pwd)":/app --net localstack_default tflocal:0.2 "apply" "-auto-approve" && cd $cwd
