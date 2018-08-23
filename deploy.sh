#!/bin/sh

source ./.env

# Create one single manifest file
target="./manifests-all.yaml"
if [ -f "$target" ]; then
  rm "$target"
fi
for file in $(find ./manifests -type f -name "*.yaml" | sort) ; do
  echo "---" >> "$target"
  cat "$file" >> "$target"
done

# replace env variable in manifest file
sed -i "s/\$NAMESPACE/$NAMESPACE/g" ./manifests-all.yaml
sed -i "s/\$MAINSITE/$MAINSITE/g" ./manifests-all.yaml
sed -i "s/\$TRUSTED_IPS/$TRUSTED_IPS/g" ./manifests-all.yaml

kubectl create namespace $NAMESPACE
kubectl -n $NAMESPACE create secret generic traefik-secret --from-literal=$BASIC_USER=$BASIC_HASH
kubectl -n $NAMESPACE create secret docker-registry myregistrykey --docker-server=$REGISTRY_SERVER --docker-username="$REGISTRY_USERNAME" --docker-password="$REGISTRY_PASSWORD" --docker-email="$REGISTRY_EMAIL"
kubectl -n $NAMESPACE apply -f ./manifests-all.yaml

rm manifests-all.yaml
