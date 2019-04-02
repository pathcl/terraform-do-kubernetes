## Terraform module for kubernetes in DigitalOcean

Hello! are you ready try out k8s on a really cheap way? you're in the right place.

This module will take you from nothing to a usable cluster in a less than 5 minutes.


## Goal

- We should spend more time on code/bussiness logic rather than infrastructure. Multi-cloud is the buzzword on the last years so why not use terraform and be adaptable?.
- In this case I created a terraform module in which you can just change 2 lines and launch your app in a managed k8s cluster for 20usd a month.

    container_image = "pathcl/goworld:0.0.5"

    container_port = "8080"

## Final result

If everything went ok you should have your app deployed and available from the internet. Take a look at the video carefully. I will start from zero as if I was doing it from first time. [HERE](https://youtu.be/4gpknNA9gG4)

## Requirements

- Aws credentials for terraform s3 remote state. Help here https://www.terraform.io/docs/providers/aws/index.html .I'm assuming is more likely you have an AWS account rather than a DO.

    Please adapt backend.tf according to your needs.
    You need to create an s3 bucket since we'll have remote state for terraform.
    More info here: https://www.terraform.io/docs/state/remote.html

- SSH key on $HOME/.ssh/ in order to install prometheus through ansible

- Docker image of your app. By default it will expose port '8080' through port 80 (internet) of a load balancer. If curious this is defined by two variables inside 'main.tf' (container_image, container_port).

- DigitalOcean account. You need to grab a API token from https://cloud.digitalocean.com/account/api/tokens . then use it in your ci/cd though an environment variable. Feeling brave? then do this on your shell:

    $ export DIGITALOCEAN_TOKEN=toomuchsecurityhere

    Best practice should be using vault.

- Terraform binary. Grab it from here: https://www.terraform.io/downloads.html

- Internet obviously :) well you can download the internet right? https://www.youtube.com/watch?v=iDbyYGrswtg

- Ok this is too boring for you. I want it all.

    $ export DIGITALOCEAN_TOKEN=toomuchsecurityhere

    $ make all

If you want to deploy prometheus through module 'prometheus' you'll need the following dependencies.

- Ansible 2.5.1
    - pip install ansible==2.5.1
- Gnu-tar:
    - brew install gnu-tar
- jmespath
    - pip install jmespath

By default it will scrape metrics from k8s.sanmartin.dev:9100. If you want to change this please go to line 40 of modules/prometheus/main.tf

## Usage

If everything is ok you should be able to do:

### Kubernetes && web app

    make kub

### Prometheus server

    make prometheus

### Clean everything

    make clean


## TODO:

Dockerfile

Proper instrumentation of homero
