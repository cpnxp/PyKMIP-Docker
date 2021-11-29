# PyKMIP-Docker
Dockerfile for PyKMIP with volume support

This is not for production use as per the base project.
This is just the containerization of PyKMIP please see: https://github.com/OpenKMIP/PyKMIP for the original project.

I am not affiliated with OpenKMIP

I created this container so I could have Virtual TPMs in vCenter and not loose the keys on the restart of the container in my homelab.

## Building
From inside the git project run the following command
```shell
docker build .
```

## Usage
Deploy the container using a command similar to this one, I have pushed this to docker hub
```shell
docker run -d -p 5696:5696 -v pykmip_data:/etc/pykmip -e "CERT_SUBJ=/C=XX/ST=Your_State/L=Your_City/O=Your_Org/OU=Your_Unit/CN=$HOSTNAME" cpnxp/pykmip-docker:latest
```
You can customize the self-signed cert subject using the CERT_SUBJ environment variable, see the OpenSSL docs for format and info.
In the above, it assumes you have already created a persistent volume named pykmip_data in docker, this is critical as it is how the config, certs and database are persisted.

See: https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.security.doc/GUID-55B17A13-13AB-4CA1-8D83-6515AA1FEC67.html on how to configure this in vCenter.
