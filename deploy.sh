#!/bin/sh

# Create one single manifest file
target="./manifests-all.yaml"
for file in $(find ./manifests -type f -name "*.yaml" | sort) ; do
  echo "---" >> "$target"
  cat "$file" >> "$target"
done

# replace env variables in manifest file
source ./.env
for line in `cat .env` ; do
  var=$(echo -n $line   | awk 'BEGIN {FS="="} {print $1}')
  value=$(echo -n $line | awk 'BEGIN {FS="="} {print $2}')
  sed -i "s%\$$var%$value%g" ./manifests-all.yaml
done

kubectl create namespace $NAMESPACE
kubectl -n $NAMESPACE create secret generic traefik-basic-secret --from-literal=auth=$BASIC_AUTH
kubectl -n $NAMESPACE create secret docker-registry myregistrykey --docker-server=$REGISTRY_SERVER --docker-username="$REGISTRY_USERNAME" --docker-password="$REGISTRY_PASSWORD" --docker-email="$REGISTRY_EMAIL"
kubectl -n $NAMESPACE apply -f ./manifests-all.yaml

rm $target
