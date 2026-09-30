# DIVE-5187 mutants (carried with the verb, DIVE-5247) — each removes one defence of the sysadmin approval. Run from
# the tree root; the row's verify_command must go red under every one of them
# (tests/sysadmin_unit.sh arm h, and arm j2 re-checks it on each commit).
set -uo pipefail
# m1: answer no longer refuses a seat caller
m1() {
  sed -i 's/^  \[\[ "\$caller" != agent-\* \]\] || fail .*$/  :/' partner/bin/sysadmin
}
# m2: the broker answers on the seat's behalf (a seat-reachable approval, the old keyboard's class)
m2() {
  sed -i 's/^    status) _sysadmin_status "\$(jq -r .\.id \/\/ "". <<<"\$req")" ;;$/&\n    answer) _sysadmin_caller() { :; }; _sysadmin_answer "$(jq -r ".id" <<<"$req")" "$(jq -r ".answer" <<<"$req")" "--sha=$(jq -r ".sha" <<<"$req")" ;;/' partner/bin/sysadmin
}
