package kubernetes.admission

import data.kubernetes.namespaces

deny[msg] {
    input.request.kind.kind = "Service"
    input.request.operation == "CREATE"
    port := input.request.object.spec.ports[_].port
    port != 443
    msg := sprintf("Port %d in not permitted", [port])
}
