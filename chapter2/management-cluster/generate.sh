#!/bin/bash
# Original Script: https://github.com/kubernetes-sigs/cluster-api-provider-aws/blob/v0.4.0/examples/generate.sh

# Versions
CAPA_VERSION="v0.4.0"
CAPI_VERSION="v0.2.1"
CABPK_VERSION="v0.1.0"
CALICO_VERSION="v3.8"

# AWS Settings
export SSH_KEY_NAME="${SSH_KEY_NAME:-cluster-api-aws-default}"
export AWS_REGION="${AWS_REGION:-ap-northeast-1}"

# Cluster Settings
export KUBERNETES_VERSION="${KUBERNETES_VERSION:-v1.15.3}"
export CLUSTER_NAME="${CLUSTER_NAME:-capi-mng}"

# Machine Settings
export CONTROL_PLANE_MACHINE_TYPE="${CONTROL_PLANE_MACHINE_TYPE:-t3.small}"
export NODE_MACHINE_TYPE="${NODE_MACHINE_TYPE:-t3.small}"

# Output Settings
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
OUTPUT_DIR=${OUTPUT_DIR:-${SOURCE_DIR}/_out}

COMPONENTS_CLUSTER_API_GENERATED_FILE=${SOURCE_DIR}/provider-components/provider-components-cluster-api.yaml
COMPONENTS_KUBEADM_GENERATED_FILE=${SOURCE_DIR}/provider-components/provider-components-kubeadm.yaml
COMPONENTS_AWS_GENERATED_FILE=${SOURCE_DIR}/provider-components/provider-components-aws.yaml

CLUSTER_GENERATED_FILE=${OUTPUT_DIR}/cluster.yaml
MACHINES_GENERATED_FILE=${OUTPUT_DIR}/machines.yaml
PROVIDER_COMPONENTS_GENERATED_FILE=${OUTPUT_DIR}/provider-components.yaml
ADDON_GENERATED_FILE=${OUTPUT_DIR}/addon.yaml

if [ -d "$OUTPUT_DIR" ]; then
  echo "ERR: Folder ${OUTPUT_DIR} already exists. Delete it manually before running this script."
  exit 1
fi

mkdir -p "${OUTPUT_DIR}"

# Generate AWS Credentials
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm alpha bootstrap encode-aws-credentials)

# Generate cluster manifest
kustomize build "${SOURCE_DIR}/cluster" | envsubst > "${CLUSTER_GENERATED_FILE}"
echo "Generated ${CLUSTER_GENERATED_FILE}"

# Generate machines manifest
kustomize build "${SOURCE_DIR}/machines" | envsubst > "${MACHINES_GENERATED_FILE}"
echo "Generated ${MACHINES_GENERATED_FILE}"

# Download & Generate provider-components.yaml
## Cluster API Provider AWS
kustomize build "github.com/kubernetes-sigs/cluster-api-provider-aws//config/default/?ref=${CAPA_VERSION}" | envsubst > "${COMPONENTS_AWS_GENERATED_FILE}"
echo "Generated ${COMPONENTS_AWS_GENERATED_FILE}"

## Cluster API
kustomize build "github.com/kubernetes-sigs/cluster-api//config/default/?ref=${CAPI_VERSION}" > "${COMPONENTS_CLUSTER_API_GENERATED_FILE}"
echo "Generated ${COMPONENTS_CLUSTER_API_GENERATED_FILE}"

## Cluster API Bootstrap Provider kubeadm
kustomize build "github.com/kubernetes-sigs/cluster-api-bootstrap-provider-kubeadm//config/default/?ref=${CABPK_VERSION}" > "${COMPONENTS_KUBEADM_GENERATED_FILE}"
echo "Generated ${COMPONENTS_KUBEADM_GENERATED_FILE}"

# Download Network Plugin (Calico) manifest
curl -sL https://docs.projectcalico.org/${CALICO_VERSION}/manifests/calico.yaml -o "${ADDON_GENERATED_FILE}"
echo "Downloaded ${ADDON_GENERATED_FILE}"

# Generate a single provider components file.
kustomize build "${SOURCE_DIR}/provider-components" | envsubst > "${PROVIDER_COMPONENTS_GENERATED_FILE}"
echo "Generated ${PROVIDER_COMPONENTS_GENERATED_FILE}"
echo "WARNING: ${PROVIDER_COMPONENTS_GENERATED_FILE} includes AWS credentials"
