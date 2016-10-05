#!/bin/sh
service () {
  cat <<EOM
apiVersion: v1
kind: Service
# Arbitrary Metadata block. Must have a name.
metadata:
  name: my-service
  #labels:
    #name: my-service
spec:
  # Optionally, have a type. Valid options are ExternalName, ClusterIP, NodePort, and LoadBalancer
  #type: NodePort
  #
  # Selector finds the target pod this service routes to.
  selector:
    name: my-pod
  ports:
    - port: 1234
      # service name for this port, must be a DNS label.
      name: my-service-port
      # targetPort can be a name or a number on the pod that we're targeting
      targetPort: 1234
      protocol: TCP
      # If 'type: NodePort', which port to expose on all machines
      #nodePort: 32378
EOM
}

ingress () {
  cat <<EOM
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  # Virtual host to match
  - host: foo.bar.com
    http:
      paths:
      # Backend to target
      - backend:
          serviceName: s1
          servicePort: 80
        # Optional path within the virtualhost
        #path: /foo
EOM

}

SUB=$1
shift
case $SUB
in
  "svc" | "service") 
    service $*;;
  "in" | "ing" | "ingress") 
    ingress $*;;
esac

