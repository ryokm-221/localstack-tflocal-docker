#!/bin/bash -e
rm -f terraform/lambda_func.zip
zip "terraform/lambda_func.zip" node_modules/ index.js package.json package-lock.json
npm run build