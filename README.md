# k8s-deployments

This repository serves as the location for managing k8s clusters with Git and Flux v2.

## Bootstrap the development cluster

Install the Flux CLI and fork this repository on your personal GitHub account
and export your GitHub username and repo name:

```sh
export GITHUB_USER=<your-username>
export GITHUB_REPO=<repository-name>
```

Verify that your development cluster satisfies the prerequisites with:

```sh
flux check --pre
```

Set the `--context` argument to the `kubectl` context to your development cluster and bootstrap Flux:

```sh
flux bootstrap github \
    --context=dev \
    --owner="${GITHUB_USER}" \
    --repository="${GITHUB_REPO}" \
    --branch=main \
    --personal \
    --path="clusters/development"
```

At this point flux cli will ask you for your `GITHUB_TOKEN` (a.k.a [Personal Access Token]).

> **NOTE:** The `GITHUB_TOKEN` is used exclusively by the flux CLI during the bootstrapping process,
> and does not leave your machine. The credential is used for
> configuring the GitHub repository and registering the deploy key.

The bootstrap command commits the manifests for the Flux components in `clusters/development/flux-system` dir
and creates a deploy key with read-only access on GitHub, so it can pull changes inside the cluster.

Wait for the development cluster reconciliation to finish:

```sh
$ flux get kustomizations --watch
NAME            	READY  	MESSAGE                                                        	
flux-system     	True   	Applied revision: main/616001c38e7bc81b00ef2c65ac8cfd58140155b8	
observability-system         	Unknown	Reconciliation in progress
```
