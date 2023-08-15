#     ./vault/bin/vault server -dev -dev-root-token-id='root' -address='http://127.0.0.1:8200' -exit-on-core-shutdown &
#     # export vault_pid=$!
#     vault_pid=$!

#     # Wait until server is up
#     until curl --output /dev/null --silent --fail -H 'X-Vault-Token: root' http://127.0.0.1:8200/v1/sys/internal/specs/openapi; do
#         sleep .1
#     done
