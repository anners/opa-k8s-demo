# opa-k8s-demo

This demonstrates how to use [Open Policy Agent OPA](https://www.openpolicyagent.org/) with Kubernetes Admission Control. This example denies any LoadBalancers that get created with any other port than 443.

To get started follow the instructions [here](https://www.openpolicyagent.org/docs/v0.11.0/kubernetes-admission-control/) for setting up a Kubernetes Admission Controller.

# Create the OPA policy

`kubectl create configmap block-nonhttps --from-file=block-nonhttps.rego`

In a nutshell this checks:
if the kind of data object being is a Service, and
if the request operation is Create, and
if the port is not 443, then
deny the request and print an error message

# Create a good service

`kubectl delete -f service-good.yaml -n production`

If this succeeds you should see `service/https-service created`

# Create a bad service

`kubectl delete -f service-bad.yaml -n production`

If this fails you should see `admission webhook "validating-webhook.openpolicyagent.org" denied the request: Port 80 is not permitted. Only 443 is permitted`

# Debugging

You should see the following in your Kubernetes logs if the bad service is denied.
`"msg": "Decision Log",
  "path": "system/main",
  "requested_by": "192.168.64.2:54396",
  "result": {
    "apiVersion": "admission.k8s.io/v1beta1",
    "kind": "AdmissionReview",
    "response": {
      "allowed": false,
      "status": {
        "reason": "Port 80 in not permitted"
      }
    }
  },
  "time": "2020-02-01T01:31:39Z",
  "timestamp": "2020-02-01T01:31:39.048070346Z",
  "type": "openpolicyagent.org/decision_logs" `
