# Changelog

Changes to the template. Your copy does not pick these up by itself, so read this
before an upgrade and port what applies to you.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

* `VSHNKeycloak` claim, env ConfigMap, realm ConfigMap generator and ArgoCD
  Application.
* Minimal example realm, `keycloak/config/realm-example.json`.
* Vault Secrets Operator example in `examples/vault/`.
* `validate` workflow: renders the manifests, checks them against the AppCat CRD
  schema and fails copies that still contain `<placeholders>`.
