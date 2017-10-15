# kuma_ci

Source to generate the `kuma_ci` docker image available at:

https://hub.docker.com/r/atsui/kuma_ci/

# Summary

`kuma` is a Rails project that is set up to use CircleCI 2.0 Workflow.
When a branch is pushed, a VM is spun up to run the project's test suite.
The VM is stored as a precompiled docker image on Docker Hub called `kuma_ci`.
`kuma_ci` has all the libraries and services set up so that it can immediately be used to configure and run the `kuma` test suite.
This project describes how to reproduce the `kuma_ci` image.
The project contains a Dockerfile that describes how to build up the image from an available base image.
The project also contains some setup scripts that are copied into the image and run via the Dockerfile to setup and configure the image.

# Prerequisites

You'll need docker installed, as well as plenty GB of free space to build/modify the image.
If you plan on publishing the image to Docker Hub, you'll need to sign up for an account on their website, and you'll need either a fast internet connection or a lot of time because the images are large.

This project makes use of but does not provide Oracle JDK.
Please obtain the Linux JDK via Oracle and place it into the project directory before trying to build the image.

# Quickstart

We'll assume you have docker installed on your system. Then,

```
docker build .
```

Example output
```
$ sudo docker build .
[sudo] password for atsui: 
Sending build context to Docker daemon  661.8MB
Step 1/29 : FROM ubuntu:trusty
 ---> dea1945146b9

...

Step 29/29 : CMD /bin/bash
 ---> Running in 5f9f987d0921
 ---> 532180804ce4
Removing intermediate container 5f9f987d0921
Successfully built 532180804ce4
```

# Publish to Docker Hub

You'll need to sign into docker first

```
docker login
```

Then you'll need to tag the image that you built

```
docker tag 532180804ce4 YOUR_DOCKER_ID/kuma_ci:TAG
```

Next, you can push to Docker Hub.

```
docker push YOUR_DOCKER_ID/kuma_ci:TAG
```

Once this completes successfully, the image will be available to be pulled.
