> Kubernetes compose orchestra for Traefik

## QuickStart
1. Uncomment the `caServer` line in manifests/configmap.yaml if you want to debug with staging Certs
2. `kubectl label nodes your-desired-node edge-node=true`
3. `cp -a .env.example .env` and update it (avoid the % char)
4. `htpasswd -nb username password` to generate http password and update `.env`
5. `./deploy`


## Some useful annotations
* For Ingress
    - traefik.ingress.kubernetes.io/auth-type: basic
    - traefik.ingress.kubernetes.io/auth-secret: mysecret_name (Name of Secret containing the username and password)
    - traefik.ingress.kubernetes.io/is-development: "true" (will cause ignore AllowedHosts、SSLRedirect、STSSeconds、STSIncludeSubdomains)
    - traefik.ingress.kubernetes.io/whitelist-source-range: "1.2.3.0/24, fe80::/16" (IP ranges permitted for access)
    - traefik.ingress.kubernetes.io/rate-limit: <YML>
    - traefik.ingress.kubernetes.io/error-pages: <YML>
    - traefik.ingress.kubernetes.io/preserve-host: "true"
    - traefik.ingress.kubernetes.io/frontend-entry-points: http,https (Overide the default entrypoints)
    - ingress.kubernetes.io/frame-deny: "true" (Adds the X-Frame-Options header with the value of DENY)
* For Service
    - traefik.ingress.kubernetes.io/affinity: "true" (For Sticky sessions)
    - traefik.ingress.kubernetes.io/session-cookie-name: "yourcookiename" (Manually set the cookie name for sticky sessions)

## Note
* HealthCheck is configured to `host:8080/ping`
* Prometheus Metrics is opened on "traefik-admin.lb.svc"
* Both static global configuration and dynamic configuration are stored to consul by a store job

## Reference
* https://github.com/helm/charts/tree/master/stable/traefik
* https://github.com/containous/traefik/blob/master/examples

## TODO
* Consider to use the alpine based image, so we can switch the timezone (for now, 1.7.0-rc4-alpine, there are still bugs such as "Datastor sync error" with the it)
* Confirm the traefik log and access log are in local time after timezone switch
