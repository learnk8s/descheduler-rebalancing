# Rebalancing Kubernetes clusters with the Descheduler

## Getting started

You need to create a Linode token to access the API:

```bash
linode-cli profile token-create
export LINODE_TOKEN=<insert the token here>
```

```bash
# Create the cluster
terraform -chdir=01-clusters init
terraform -chdir=01-clusters apply -auto-approve

# Cleanup
terraform -chdir=01-clusters destroy -auto-approve
```

Make sure that your kubectl is configured with the current kubeconfig file:

```bash
export KUBECONFIG="${PWD}/kubeconfig"
```

## Installing the descheduler

Deploy podinfo:

```bash
kubectl apply -f 03-demo/01-stress.yaml
```

Deploy the descheduler with:

```bash
kubectl apply -f 03-demo/02-descheduler.yaml
```

## Dashboard

```bash
kubectl proxy --www=./dashboard
```

## Restart

```bash
kubectl apply -f 03-demo/03-restart.yaml
```

## Duplicates

First cordon one of the nodes:

```bash
kubectl get nodes
kubectl cordon <node name>
```

Then evict the pods

```bash
kubectl drain <node name>
```

Scale the deployment to 3 replicas:

```bash
kubectl scale --replicas=3 deployment/app
```

Confirm that the three replicas are running only in two nodes:

```bash
kubectl get pods -o wide
```

Apply the duplicate policy:

```bash
kubectl apply -f 03-demo/04-duplicates.yaml
```

Finally, uncordon the node and observe the descheduler deleting the pod:

```bash
kubectl uncordon <node name>
```

## Low utilization

Apply the low utilization policy:

```bash
kubectl apply -f 03-demo/05-usage.yaml
```

Cordon one of the nodes:

```bash
kubectl get nodes
kubectl cordon <node name>
```

Then evict the pods

```bash
kubectl drain <node name>
```

Scale the deployment to 12 replicas:

```bash
kubectl scale --replicas=12 deployment/app
```

Confirm that the three replicas are running only in two nodes:

```bash
kubectl get pods -o wide
```

Finally, uncordon the node and observe the descheduler rebalancing the pods:

```bash
kubectl uncordon <node name>
```
