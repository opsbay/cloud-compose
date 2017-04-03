# cloud-compose

A simple [Packer](https://www.packer.io/) script to create an
[Ubuntu](https://www.ubuntu.com/) based 
[AMI](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) to run 
[Docker Compose](https://docs.docker.com/compose/) applications from
a [cloud-init](http://cloudinit.readthedocs.io/)
[user-data](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html).

[EC2 tags](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html) will become environment variables
(written to a [`.env` file](https://docs.docker.com/compose/environment-variables/#the-env-file)).

A `docker login` will be done if a value is found for `docker.username` and `docker.password` into 
[EC2 Systems Manager](http://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html)
using [GetParameters](http://docs.aws.amazon.com/systems-manager/latest/APIReference/API_GetParameters.html).

## Create the AMI

```sh
$ git clone https://github.com/pierredavidbelanger/cloud-compose
$ cd cloud-compose
$ packer build \
    -var 'aws_region=us-east-2' \
    -var 'aws_source_ami=ami-fcc19b99' \
    ami.json
```

## Use the AMI

Launch an EC2 instance with the AMI created above and this user-data content:

```yaml
#cloud-config
write_files:
  - path: /var/lib/cloud-compose/docker-compose.yml
    content: |
      version: '3'
      services:
        hello-world:
          image: tutum/hello-world
          restart: always
          ports:
            - 8080:80
```