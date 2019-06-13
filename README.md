
# BBCORP - Scenario 3 - Network List Pipeline Toolkit

This project is used for BBCORP Akamai Network List management automation, using the [Akamai Network List API V2](https://developer.akamai.com/api/cloud_security/network_lists/v2.html)

The scripts and Jenkinsfile contained in this project perform the following functions within a simple CI process:

1. Update existing Network List from source CSV file
2. Activate the Network List on either production or staging networks



## Installation

All necessary packages are included in Dockerfile. Use docker to install:

```
$ docker build <name-of-your-image> /<path-to-your-dockerfile>/.
```

Create a docker volume to include your credentials in order to avoid to enter them each time :

```
$ docker volume create --name <name-of-your-volume>
$ docker volume inspect <name-of-your-volume>
[
    {
        "CreatedAt": "YYYY-MM-DDTHH:MM:SS+02:00",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "<path-to-volume-data>",
        "Name": "<name-of-volume>",
        "Options": {},
        "Scope": "local"
    }
]

// Set your credentials in this file
$ vi /<path-to-volume-data>/.edgerc
```

If you are not using the jenkins pipeline, you can run the docker container locally :


```
$ docker run -it --mount source=<name-of-your-volume>,target=/root/data -u 0:0 <name-of-your-image>
```

## Python Artifacts

### updateNetworkList.py

Used to append or overwrite a network list, using a source CSV file.

```
usage: updateNetworkList.py [-h] [--file FILE] [--delimiter DELIMITER]
                            [--action ACTION] [--config CONFIG]
                            [--section SECTION]
                            list-name

Network List Updater

positional arguments:
  list-name             The name of our network list.

optional arguments:
  -h, --help            show this help message and exit
  --file FILE           Path to CSV file with IPs for our network list.
                        (default: $HOME/list.csv)
  --delimiter DELIMITER
                        CSV delimiter used, if not ',' (default: ,)
  --action ACTION       The action to take on the network list. Supported
                        options are: append or overwrite.' (default: append)
  --config CONFIG       Full or relative path to .edgerc file (default:
                        $HOME/.edgerc)
  --section SECTION     The section of the edgerc file with the proper Akamai
                        API credentials. (default: default)
```

### activateNetworkList.py

Activate the updated network list on either the production or staging network.

```
usage: activateNetworkList.py [-h] --network NETWORK --email EMAIL
                              [--comment COMMENT] [--config CONFIG]
                              [--section SECTION]
                              list-name

Network List Activator

positional arguments:
  list-name          The name of our network list.

optional arguments:
  -h, --help         show this help message and exit
  --network NETWORK  Activation network: production or staging (default:
                     staging)
  --email EMAIL      Comma delimited e-mail list, for activation e-mail
                     notifications. (default: None)
  --comment COMMENT  Activation comments. (default: None.)
  --config CONFIG    Full or relative path to .edgerc file (default:
                     $HOME/.edgerc)
  --section SECTION  The section of the edgerc file with the proper Akamai API
                     credentials. (default: default)
```

## Jenkins Pipeline

The included Jenkinsfile implements a declarative Pipeline to orchestrate the update and activation of the network list, given the source CSV file.
Edit the environment variables prior to executing the Pipeline build.
Install Plugin "Copy Artifcat" in Jenkins.
