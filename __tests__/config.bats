#!/usr/bin/env bats

@test "uninitialized contract" {
  run cleos transfer user1 pomelo "1000.0000 EOS" "grant:grant1"
  echo "Output: $output"
  [ $status -eq 1 ]
  [[ "$output" =~ "[status] key does not exists" ]]
}

@test "contract under maintenance" {
  run cleos push action pomelo init '[0, 2]' -p pomelo
  [ $status -eq 0 ]

  run cleos transfer user1 pomelo "1000.0000 EOS" ""
  echo "Output: $output"
  [ $status -eq 1 ]
  [[ "$output" =~ "contract is under maintenance" ]]
}

@test "set config" {
  run cleos push action pomelo init '[0, 1]' -p pomelo
  echo "Output: $output"
  [ $status -eq 0 ]

  result=$(cleos get table pomelo pomelo globals | jq -r '.rows[1].value')
  [ $result = "1" ]

}
