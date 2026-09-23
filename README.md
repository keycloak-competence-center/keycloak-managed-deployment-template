# Managed Keycloak deployment template

A starting point for the Git repository that deploys a
[VSHN Managed Keycloak](https://docs.appcat.ch/vshn-managed/keycloak/) (AppCat) on
APPUiO through your own ArgoCD.

## About this template

Maintained by the [Keycloak Competence Center](https://keycloak.ch), third level
support for VSHN Managed Keycloak. Create your own repository from it with **Use
this template**, fill in the placeholders and replace the example realm. See [CHANGELOG.md](CHANGELOG.md) for what changed.

Not covered: custom Keycloak images, installing ArgoCD, DNS and the APPUiO
organisation setup.

## Layout

```
keycloak/                 synced by ArgoCD
  vshnKeycloak.yaml       the instance itself, start here
  env-configmap.yaml      non-secret env vars, for Keycloak and the realm JSONs
  config/                 second sync source
    kustomization.yaml    renders your realm JSONs into a ConfigMap
    realm-example.json    minimal example, replace with your realm exports
bootstrap/                not synced, applied by hand
  application.yaml        ArgoCD Application, apply once
  secret.example.yaml     shape of the env var Secret, do not commit real values
examples/                 not synced
  vault/                  the Secret from the Vault Secrets Operator instead
```

ArgoCD directory sources are not recursive. `keycloak/` therefore contributes only
the manifests directly inside it, and `keycloak/config/` is listed as a second
source. A manifest put in a deeper subdirectory is silently ignored, so keep new
resources flat in `keycloak/` or give them their own source. `bootstrap/` is outside
both sources on purpose: it holds the two files that must never be applied by a
sync.

## Prerequisites

* A namespace on APPUiO with the AppCat Keycloak offering enabled.
* An ArgoCD with read access to this repository. If it is a namespace scoped
  OpenShift GitOps instance, label the target namespace so it may manage it:

  ```sh
  oc label namespace <your-namespace> argocd.argoproj.io/managed-by=<your-argocd-namespace>
  ```

* A DNS CNAME for the FQDN pointing at your APPUiO zone endpoint, for example
  `cname.cloudscale-lpg-0.appuio.cloud`. The certificate is then issued and renewed
  for you.

## Setup

1. Replace every `<placeholder>` in `keycloak/` and `bootstrap/`. The ones that
   matter are the FQDN, the namespace, the admin group and the Git repository URL.
2. Copy your realm JSONs into `keycloak/config/`, list them in
   `config/kustomization.yaml` and delete `realm-example.json`.
3. Create the `keycloak-env` Secret in the namespace, by hand once or from your
   secret store. See `bootstrap/secret.example.yaml` and `examples/`.
4. `oc apply -f bootstrap/application.yaml`. ArgoCD owns everything from here.

## Realm configuration

`service.customConfigurationRef` names a ConfigMap in the claim namespace. Every key
in it becomes a file under `/opt/keycloak/setup/project`, and keycloak-config-cli
imports all of them on every start. The ConfigMap is generated from
`config/kustomization.yaml`, so adding a realm means adding a JSON file and an entry
in `files:`.

Realm JSONs can reference environment variables as `$(env:NAME:-default)`. The
values come from whatever `service.envFrom` points at, which is how the same realm
export serves several environments: secrets and per environment hostnames stay out
of the JSON. A common pattern is `"enabled": "$(env:SOME_CLIENT_ENABLED:-false)"`,
so a client exists in every environment but is only switched on where it is wanted.

Imports are additive. Removing a client from the JSON does not remove it from
Keycloak.

## Environment variables

`service.envFrom` reads two objects, and the split decides what ends up in Git:

* `env-configmap.yaml`, committed here, holds `KC_*` settings and every non-secret
  value the realm JSONs interpolate: hostnames, IdP endpoint URLs, timeouts, feature
  switches.
* the `keycloak-env` Secret holds client secrets and credentials, and is never
  committed.

The Secret is listed second, so it can override a key from the ConfigMap. VSHN sets
`KC_HOSTNAME`, `KC_HOSTNAME_ADMIN`, `KC_HTTP_RELATIVE_PATH`, the database settings
and the HTTPS certificate paths as container env, which outranks both.

## Branch per environment

One branch per environment, one ArgoCD Application per branch, both pointed at each
other through `targetRevision`. Changes land on the test branch first, then move to
the production branch by merge request. That keeps the promotion an ordinary review
of a diff.

## Admin console

`adminConsole.private: true` keeps the console off the public FQDN. Reach it with a
port-forward into the instance namespace, which is `vshn-keycloak-<instance-name>`:

```sh
oc port-forward -n vshn-keycloak-keycloak svc/<instance>-keycloakx-http 8080:80
```

The admin credentials are in the Secret named by `writeConnectionSecretToRef`.
Membership in one of `security.allowedGroups` is what grants access to that
namespace. To publish the console on a separate hostname instead, set
`adminConsole.fqdn` and drop `private`.

## Custom themes and extensions

VSHN runs its own Keycloak image. To ship custom themes or providers, build an image
from https://github.com/vshn/custom-keycloak-image-template and set
`service.customImage`. Note that this pins the version: automatic upgrades during
the maintenance window stop, and keeping up to date becomes your responsibility.

## Reference

* https://docs.appcat.ch/vshn-managed/keycloak/
* Plans and sizing: https://docs.appcat.ch/vshn-managed/keycloak/plans.html
