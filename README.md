> Kubernetes compose orchestry for Traefik

## QuickStart
1. `kubectl label nodes your-desired-node edge-node=true`
2. `cp -a .env.example .env` and update it
3. generate your BASIC_USER:BASIC_HASH with htpasswd command (`htpasswd -nb user password`) and update .env
4. `./deploy`

## Some useful annotations
* For Ingress
    - traefik.ingress.kubernetes.io/preserve-host: "true"
    - traefik.ingress.kubernetes.io/auth-type: basic
    - traefik.ingress.kubernetes.io/auth-secret: mysecret_name (Name of Secret containing the username and password)
    - traefik.ingress.kubernetes.io/frontend-entry-points: http,https (Overide the default entrypoints)
* For Service
    - traefik.ingress.kubernetes.io/affinity: "true" (For Sticky sessions)
    - traefik.ingress.kubernetes.io/session-cookie-name: "yourcookiename" (Manually set the cookie name for sticky sessions)

## Note
* HealthCheck is configured to `host:8080/ping`
* Prometheus Metrics is opened on "traefik-admin.lb.svc"
* Both static global configuration and dynamic configuration are stored in consul by a store job

## Reference
* https://github.com/helm/charts/tree/master/stable/traefik
* https://github.com/containous/traefik/blob/master/examples
