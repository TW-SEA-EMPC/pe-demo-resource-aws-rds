#!/usr/bin/env bash
WORKING_DIR=$(dirname $(realpath $0))
echo $WORKING_DIR

RED="\033[31m"
GREEN="\033[32m"
RESET="\033[0m"

COMPONENT=$1
ENVIRONMENT=$2
TEAM=$3
CONFIG_FILE_PATH=$4


if [[ -z $COMPONENT ]]; then
	echo -e "${RED}Please specify the COMPONENT eg > ${GREEN}tf.sh <component> <environment> <team> <config_file_path>${RESET}"
  exit 1
fi

if [[ -z $ENVIRONMENT ]]; then
	echo -e "${RED}Please specify the ENVIRONMENT and TEAM for the STACK${RESET} eg > ${GREEN}tf.sh <component> <environment> <team> <config_file_path>${RESET}"
  exit 1
fi

if [[ -z $TEAM ]]; then
	echo -e "${RED}Please specify the COMPONENT, ENVIRONMENT and TEAM for the STACK${RESET} eg > ${GREEN}tf.sh <component> <environment> <team> <config_file_path>${RESET}"
  exit 1
fi

if [[ -z $CONFIG_FILE_PATH ]]; then
	echo -e "${RED}Please specify the COMPONENT, ENVIRONMENT, TEAM and CONFIG_FILE_PATH for the STACK${RESET} eg > ${GREEN}tf.sh <component> <environment> <team> <config_file_path>${RESET}"
  exit 1
fi
CONFIG_FILE_PATH=$(realpath $CONFIG_FILE_PATH)

STACK="rds"
PLATFORM_ENVIRONMENT="iqa"
pushd ${WORKING_DIR}
terraform init --backend-config="key=${PLATFORM_ENVIRONMENT}/${COMPONENT}-${ENVIRONMENT}-${STACK}"
terraform apply --var-file="${CONFIG_FILE_PATH}"\
  -var "component=${COMPONENT}" \
  -var "environment=${ENVIRONMENT}" \
  -var "team=${TEAM}"
popd
