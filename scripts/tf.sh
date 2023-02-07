#!/usr/bin/env bash

RED="\033[31m"
GREEN="\033[32m"
RESET="\033[0m"

COMMAND=$1
ENVIRONMENT=$2
STACK=$3

if [[ -z $STACK ]]; then
	echo -e "${RED}Please specify the STACK eg > ${GREEN}tf.sh <command> <environment> <stack> ${RESET}"
  exit 1
fi

if [[ -z $ENVIRONMENT ]]; then
	echo -e "${RED}Please specify the ENVIRONMENT for the STACK${RESET}"
  exit 1
fi

init() {
  terraform init --backend-config="key=$ENVIRONMENT/$STACK" -reconfigure
}
init-upgrade() {
  terraform init --upgrade --backend-config="key=$ENVIRONMENT/$STACK" -reconfigure
}
plan() {
  terraform plan --var-file=environments/"${ENVIRONMENT}".tfvars
}
apply() {
  terraform apply --var-file=environments/"${ENVIRONMENT}".tfvars
}
apply-auto() {
  terraform apply --var-file=environments/"${ENVIRONMENT}".tfvars -auto-approve
}
destroy() {
  terraform destroy --var-file=environments/"${ENVIRONMENT}".tfvars
}
lint() {
	docker run --rm --entrypoint=/bin/sh -v $(pwd):/data -t ghcr.io/terraform-linters/tflint:latest  -c "tflint --init && tflint --module"
}
sec() {
	docker run --rm -v "$(pwd):/src" aquasec/tfsec /src
}

# Check if the function exists (bash specific)
if declare -f "$COMMAND" > /dev/null
then
  # call arguments verbatim
  "$COMMAND"
else
  # Show a helpful error
  echo "${RED}'$COMMAND' is not a known function name${RESET}" >&2
  exit 1
fi
