## Features

* The container is based on the official eDirectory Docker image.
* The container can be started with a variety of configuration options, including the tree name, admin DN, and admin password.
* The container includes a number of pre-configured features, such as the eDirectory Business Administrator (EBA).

## Usage

To use the eDirectory Docker container, you will need to have Docker installed on your machine. Once Docker is installed, you can start the container using the following command:


`docker run -d --name edirectory -p 8080:8080 -p 443:443 edirectory/edirectory`
This will start the container and expose the eDirectory web console on ports 8080 and 443. You can then access the web console by opening a web browser and navigating to http://localhost:8080.

## Configuration
The eDirectory Docker container can be configured using a variety of environment variables. The following table lists the available environment variables and their descriptions:

Environment Variable	Description
* Environment Variable	Description
* `CONTAINER_NAME`	The name of the container.
* `SOURCE_IMAGE`	The name of the Docker image to use.
* `IP`	The IP address of the host machine.
* `NCP_PORT`	The port number for the eDirectory NCP service.
* `SERVER_CONTEXT`	The server context for the eDirectory server.
* `SERVER_NAME`	The name of the eDirectory server.
* `TREENAME`	The name of the eDirectory tree.
* `ADMIN_DN`	The DN of the eDirectory administrator.
* `ADMIN_SECRET`	The password of the eDirectory administrator.
* `LDAP_PORT`	The port number for the eDirectory LDAP service.
* `SSL_PORT`	The port number for the eDirectory SSL service.
* `HTTP_PORT`	The port number for the eDirectory HTTP service.
* `HTTPS_PORT`	The port number for the eDirectory HTTPS service.*
## Troubleshooting
If you encounter any problems with the eDirectory Docker container, you can try the following troubleshooting steps:

* Make sure that you have Docker installed and running.
* Make sure that the correct Docker image is being used.
* Verify that the environment variables are set correctly.
* Check the logs for the container for any errors.
