#!/usr/bin/env bash
WORKING_DIR=$(dirname $(realpath $0))
echo $WORKING_DIR

RED="\033[31m"
GREEN="\033[32m"
RESET="\033[0m"

COMPONENT=$1
ENVIRONMENT=$2
TEAM=$3
# Read remaining inputs as an array
CONFIG_FILE_PATHS=("${@:4}")

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

if [[ -z $CONFIG_FILE_PATHS ]]; then
	echo -e "${RED}Please specify the COMPONENT, ENVIRONMENT, TEAM and CONFIG_FILE_PATHS the STACK${RESET} eg > ${GREEN}tf.sh <component> <environment> <team> <config_file_path> ${RESET}"
  exit 1
fi

# transform CONFIG_FILE_PATHS array into realapth of each element
CONFIG_FILE_PATHS=($(realpath "${CONFIG_FILE_PATHS[@]}"))
VAR_FILE_ARGS="${CONFIG_FILE_PATHS[@]/#/--var-file=}"

echo "${VAR_FILE_ARGS}"

STACK="rds"
PLATFORM_ENVIRONMENT="iqa"
pushd ${WORKING_DIR}
terraform init --backend-config="key=${PLATFORM_ENVIRONMENT}/${COMPONENT}-${ENVIRONMENT}-${STACK}" --reconfigure
terraform destroy \
  ${VAR_FILE_ARGS} \
  -var "component=${COMPONENT}" \
  -var "environment=${ENVIRONMENT}" \
  -var "team=${TEAM}"
popd
