# @mamezou-tech/buildpacks-action

![Run action](https://github.com/mamezou-tech/buildpacks-action/workflows/Run%20action/badge.svg)

Build container image with [Cloud Native Buildpacks](https://buildpacks.io) in GitHub Actions.

```yaml
on: [push]
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    - name: Build image
      uses: mamezou-tech/buildpacks-action@master
      with:
        image: 'foo-app'
        tag: '1.0.0'
        path: 'path/to/foo-app/'
        builder: 'gcr.io/paketo-buildpacks/builder:base'
        env: 'HELLO=WORLD FOO=BAR BAZ'
        publish: true

    - name: Push image
```

> buildpacks v0.13.1 will be executed.

## Inputs
- `image` : (required) Name of container image.
- `tag` : (optional) Tag of container image. Default `latest`
- `path` : (required) Path to target application.
- `builder` : (required) Builder to use.
- `buildpacks` : (optional) URLs or Paths to Custom buildpacks, space separated.
- `env` : (optional) Environment variables, space separated.
- `registry` : (optional) Registry to push image
- `publish` : (optional) Set to `true` if you want to push to registry

## Outputs
- `command` : The actual pack command issued
- `image-name` : The composition of the image name

> See "[Cloud Native Buildpack Documentation · Environment variables](https://buildpacks.io/docs/app-developer-guide/environment-variables/)" for environment valiables.


Example of building with buildpack

```yaml
on: [push]
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    - name: Build image
      uses: mamezou-tech/buildpacks-action@master
      with:
        image: 'sample-java-maven-app'
        path: 'samples/apps/java-maven/'
        builder: 'cnbs/sample-builder:alpine'
        buildpacks: 'samples/buildpacks/java-maven samples/buildpacks/hello-processes/ cnbs/sample-package:hello-universe'
```

Example of using AWS ECR with buildpack publish

````yaml
on: [push]
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    - uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1

    - id: login-ecr
      uses: aws-actions/amazon-ecr-login@v1

    - name: Build image and publish to ECR
      id: build-image
      uses: mamezou-tech/buildpacks-action@master
      with:
        registry: ${{ steps.login-ecr.outputs.registry }}
        image: 'foo-app'
        tag: '1.0.0'
        path: 'path/to/foo-app/'
        builder: 'heroku/buildpacks:18'
        publish: true

    - name: Update Task Definition and Service
