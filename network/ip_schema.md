## Purpose
- The purpose of this document is to annotate the expected IP schema to support execution. 

- All IPs and hostnames below were used during lab testing and are subject to change based on mission requirements and needs. 

## Server Setup IPs
- **Server** *(This is the IP to the actual server nic)*
    - IP: 10.0.3.28
    - Hostname: chiips-hub-server.chiips-hub

- **Openshift** *(See DNS and NTP setups for additional hostname and IP information)*
    - IP: 10.0.3.29
    - Hostname: api.hub-main.chiips-hub

- **DNS & Chrony Server** *(See DNS and NTP setups for additional information)*
    - IP: 10.0.2.51 (Used in lab setting)
    - Hostname: chiips-dns-ntp.chiips-hub
    - Notes:
        - This can be altered based on needs; however, all configuration files currently look for this outside of the 10.0.3.0/24 network. 
        - This is to allow for other services to use it if they need to without operating on the same network space as the cluster. 
        - The configs explicity allow 10.0.3.0/24 and 10.0.2.0/24 to access the DNS and Chrony services. 

## Additional Systems
- **Jetson Orin AGX 1**
    - IP: 10.0.3.33
    - Hostname: chiips-jetson-audio.chiips-hub

- **Jetson Orin AGX 2**
    - IP: 10.0.3.34
    - Hostname: chiips-jetson-video.chiips-hub
