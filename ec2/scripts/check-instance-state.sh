#!/usr/bin/env sh

instanceId=$1
echo "Waiting for instance system status = "ok" for $instanceId ..."

waitfor_sysstatus_ok_describe() {
  tries=0
  while [[ $tries -le 20 ]]
  do
    echo "Try # $tries"
    STATE=$(aws ec2 describe-instances --instance-ids $instanceId --output text --query 'Reservations[*].Instances[*].State.Name')
    echo "Run Status: $STATE"
    SYSTEMSTATUS=$(aws ec2 describe-instance-status --instance-ids $instanceId --output text --query 'InstanceStatuses[*].SystemStatus.Status')
    echo "SystemStatus: $SYSTEMSTATUS"
    if [[ $STATE != "running" || $SYSTEMSTATUS != "ok" ]]; then
      echo "Sleeping 5 ..."
      sleep 5
    fi
    (( tries++ ))
  done
}

waitfor_sysstatus_ok_aws_ssm() {
  tries=0
  responseCode=1
  while [[ $responseCode != 0 && $tries -le 10 ]]
  do
    echo "Try # $tries"
    cmdId=$(aws ssm send-command --document-name AWS-RunShellScript --instance-ids $instanceId --parameters commands="whoami" --query Command.CommandId --output text)
    sleep 5
    responseCode=$(aws ssm get-command-invocation --command-id $cmdId --instance-id $instanceId --query ResponseCode --output text)
    echo "ResponseCode: $responseCode"
    if [[ $responseCode != 0 ]]; then
      echo "Sleeping ..."
      sleep 60
    fi
    (( tries++ ))
  done
  echo "Wait time over. ResponseCode: $responseCode"
}


waitfor_sysstatus_ok() {
  responseCode=$(aws ec2 wait system-status-ok --instance-ids $instanceId)
  echo "Wait time over. ResponseCode: $responseCode"
}

###
# Main body of script starts here
###
echo "Start of script..."
waitfor_sysstatus_ok
echo "End of script..."


