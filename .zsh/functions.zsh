#!/usr/bin/env bash

function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

function setKubeconfig() {
  if [[ -z "${1}" ]]; then
    echo "cluster parameter is required, no changes were made"
    exit 1
  fi

  if [[ "${1}" == "dev" ]]; then
    if ! ( nc -zv localhost 8888 >/dev/null 2>&1 ); then
      gcloud compute ssh ny-dmv-jumpbox \
        --tunnel-through-iap \
        --project dmv-digital-intake-dev \
        --zone us-east4-c \
        -- -L 8888:localhost:8888 -N -q -f >/dev/null 2>&1
    fi
    alias kubectl="HTTPS_PROXY=localhost:8888 command kubectl"
    alias kubens="HTTPS_PROXY=localhost:8888 kubens"
    alias helm="HTTPS_PROXY=localhost:8888 command helm"
    alias k9s="HTTPS_PROXY=localhost:8888 command k9s"
    alias argocd="HTTPS_PROXY=localhost:8888 command argocd"
  elif [[ "${1}" == "qa" ]]; then
    if ! ( nc -zv localhost 8889 >/dev/null 2>&1 ); then
      gcloud compute ssh ny-dmv-jumpbox \
        --tunnel-through-iap \
        --project dmv-digital-intake-qa \
        --zone us-east4-c \
        -- -L 8889:localhost:8888 -N -q -f >/dev/null 2>&1
    fi
    alias kubectl="HTTPS_PROXY=localhost:8889 command kubectl"
    alias kubens="HTTPS_PROXY=localhost:8889 kubens"
    alias helm="HTTPS_PROXY=localhost:8889 command helm"
    alias k9s="HTTPS_PROXY=localhost:8889 command k9s"
    alias argocd="HTTPS_PROXY=localhost:8889 command argocd"
  elif [[ "${1}" == "prod" ]]; then
    if ! ( nc -zv localhost 8890 >/dev/null 2>&1 ); then
      gcloud compute ssh ny-dmv-jumpbox \
        --tunnel-through-iap \
        --project dmv-digital-intake \
        --zone us-east4-c \
        -- -L 8890:localhost:8888 -N -q -f >/dev/null 2>&1
    fi
    alias kubectl="HTTPS_PROXY=localhost:8890 command kubectl"
    alias kubens="HTTPS_PROXY=localhost:8890 kubens"
    alias helm="HTTPS_PROXY=localhost:8890 command helm"
    alias k9s="HTTPS_PROXY=localhost:8890 command k9s"
    alias argocd="HTTPS_PROXY=localhost:8890 command argocd"
  else
    unalias kubectl 2>/dev/null
    unalias kubens 2>/dev/null
    unalias helm 2>/dev/null
    unalias k9s 2>/dev/null
    unalias argocd 2>/dev/null
  fi

  export KUBECONFIG="${HOME}/.kube/${1}-kubeconfig"
  # kubeon
}

for filename in ~/.kube/*-kubeconfig; do
  PREFIX_K8S=$(basename "${filename}" "-kubeconfig")
  eval "k8s${PREFIX_K8S}() { setKubeconfig '${PREFIX_K8S}'; }"
done

function k8snone() {
  # kubeoff
  unset KUBECONFIG
  unalias kubectl 2>/dev/null
  unalias kubens 2>/dev/null
  unalias helm 2>/dev/null
  unalias k9s 2>/dev/null
}
