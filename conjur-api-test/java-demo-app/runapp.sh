java  -DCONJUR_APPLIANCE_URL=https://dap-master.cyberark.local/api \
  -DCONJUR_ACCOUNT="cyberark" \
  -DCONJUR_AUTHN_LOGIN=host/java/demo-app \
  -DCONJUR_AUTHN_API_KEY="x5fyba2abs0r610qz9752rjd6z84m3wh63nbsh87b04kdj6ccdry" \
  -DVARIABLE_ID="Vault/Demo/DB-App/oradb-testapp/password" \
  -jar target/java-demo-app-1.0-SNAPSHOT.jar
