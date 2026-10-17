# Exercise 04: Docker Networking with Multiple Containers

## Overview
Demonstrates Docker bridge networking and automated DNS container resolution across three services:
1. Python Flask REST API (`flask` container)
2. MySQL database (`mysql` container)
3. Redis cache (`redis` container)

## Deliverables
- `app/app.py`: Flask REST API serving `/about`.
- `app/requirements.txt`: Pinned Flask and Werkzeug dependencies.
- `app/Dockerfile`: Multi-tool container with `iputils-ping` and Python runtime.
- `run_ex4.sh`: Execution script covering all 6 lab tasks.

## Commands Executed
```bash
docker network create --driver bridge my-bridge-net
docker network ls
docker network inspect my-bridge-net
docker build -t flask-api .
docker run -d --name mysql --net=my-bridge-net -e MYSQL_ROOT_PASSWORD=rootpassword mysql:latest
docker run -d --name redis --net=my-bridge-net redis:latest
docker run -d --name flask --net=my-bridge-net -p 5001:5001 flask-api
curl http://localhost:5001/about
docker exec flask ping -c 3 mysql
docker exec flask ping -c 3 redis
docker stop mysql redis flask && docker rm mysql redis flask
docker network rm my-bridge-net
```

## Expected Result
- User bridge network created with private subnet `172.18.0.0/16`.
- Containers assigned IP addresses on `my-bridge-net`.
- External HTTP access via `http://localhost:5001/about`.
- Successful ICMP ping between containers using container hostnames (0% packet loss).
- Complete cleanup of containers and network.

## Verification Status
- **Status:** PASS
- **Flask REST API:** Responding `{"description":"This is a simple REST API built with Flask.","name":"Simple REST API","version":"1.0"}`
- **Ping MySQL:** 3 packets transmitted, 3 received, 0% packet loss.
- **Ping Redis:** 3 packets transmitted, 3 received, 0% packet loss.
- **Output:** Captured in `terminal-output.txt`

## Terminal Execution Output

``text
=== EXERCISE 4: DOCKER NETWORKING WITH MULTIPLE CONTAINERS ===
### Task 1: Create a Bridge Network
$ docker network create --driver bridge my-bridge-net
23a2bf65960c694c78912c16098a8d59fdb5a04d6ec9c09528af6948a41d7ca0

### Task 2: Verify the Network
$ docker network ls
23a2bf65960c   my-bridge-net   bridge    local

### Task 3: Inspect the Network
$ docker network inspect my-bridge-net | head -n 25
[
    {
        "Name": "my-bridge-net",
        "Id": "23a2bf65960c694c78912c16098a8d59fdb5a04d6ec9c09528af6948a41d7ca0",
        "Created": "2026-10-11T14:18:24.170482991Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv4": true,
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "IPRange": "",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""

### Task 4: Launch Containers
$ docker build -t flask-api .
Sending build context to Docker daemon  4.096kB

Step 1/8 : FROM python:3.9-slim
 ---> 2d97f6910b16
Step 2/8 : WORKDIR /app
 ---> Using cache
 ---> 4bc888a04dfd
Step 3/8 : COPY requirements.txt .
 ---> efe34875a14b
Step 4/8 : COPY app.py .
 ---> 1d7dcf8382fa
Step 5/8 : RUN apt-get update && apt-get install -y iputils-ping curl && rm -rf /var/lib/apt/lists/*
 ---> Running in c1f9ca218205
Get:1 http://deb.debian.org/debian trixie InRelease [140 kB]
Get:2 http://deb.debian.org/debian trixie-updates InRelease [47.3 kB]
Get:3 http://deb.debian.org/debian-security trixie-security InRelease [43.4 kB]
Get:4 http://deb.debian.org/debian trixie/main amd64 Packages [9678 kB]
Get:5 http://deb.debian.org/debian trixie-updates/main amd64 Packages [4412 B]
Get:6 http://deb.debian.org/debian-security trixie-security/main amd64 Packages [266 kB]
Fetched 10.2 MB in 3s (3571 kB/s)
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  bash-completion krb5-locales libbrotli1 libcom-err2 libcurl4t64
  libgnutls30t64 libgssapi-krb5-2 libidn2-0 libk5crypto3 libkeyutils1
  libkrb5-3 libkrb5support0 libldap-common libldap2 libnghttp2-14 libnghttp3-9
  libp11-kit0 libpsl5t64 librtmp1 libsasl2-2 libsasl2-modules
  libsasl2-modules-db libssh2-1t64 libtasn1-6 libunistring5
  linux-sysctl-defaults publicsuffix
Suggested packages:
  gnutls-bin krb5-doc krb5-user libsasl2-modules-gssapi-mit
  | libsasl2-modules-gssapi-heimdal libsasl2-modules-ldap libsasl2-modules-otp
  libsasl2-modules-sql
The following NEW packages will be installed:
  bash-completion curl iputils-ping krb5-locales libbrotli1 libcom-err2
  libcurl4t64 libgnutls30t64 libgssapi-krb5-2 libidn2-0 libk5crypto3
  libkeyutils1 libkrb5-3 libkrb5support0 libldap-common libldap2 libnghttp2-14
  libnghttp3-9 libp11-kit0 libpsl5t64 librtmp1 libsasl2-2 libsasl2-modules
  libsasl2-modules-db libssh2-1t64 libtasn1-6 libunistring5
  linux-sysctl-defaults publicsuffix
0 upgraded, 29 newly installed, 0 to remove and 30 not upgraded.
Need to get 5763 kB of archives.
After this operation, 18.5 MB of additional disk space will be used.
Get:1 http://deb.debian.org/debian trixie/main amd64 libunistring5 amd64 1.3-2 [477 kB]
Get:2 http://deb.debian.org/debian trixie/main amd64 libidn2-0 amd64 2.3.8-2 [109 kB]
Get:3 http://deb.debian.org/debian trixie/main amd64 iputils-ping amd64 3:20240905-3 [51.2 kB]
Get:4 http://deb.debian.org/debian trixie/main amd64 linux-sysctl-defaults all 4.12.1 [5724 B]
Get:5 http://deb.debian.org/debian trixie/main amd64 bash-completion all 1:2.16.0-7 [319 kB]
Get:6 http://deb.debian.org/debian trixie/main amd64 krb5-locales all 1.21.3-5+deb13u1 [101 kB]
Get:7 http://deb.debian.org/debian trixie/main amd64 libbrotli1 amd64 1.1.0-2+b7 [307 kB]
Get:8 http://deb.debian.org/debian trixie/main amd64 libkrb5support0 amd64 1.21.3-5+deb13u1 [33.1 kB]
Get:9 http://deb.debian.org/debian trixie/main amd64 libcom-err2 amd64 1.47.2-3+b12 [25.0 kB]
Get:10 http://deb.debian.org/debian trixie/main amd64 libk5crypto3 amd64 1.21.3-5+deb13u1 [81.2 kB]
Get:11 http://deb.debian.org/debian trixie/main amd64 libkeyutils1 amd64 1.6.3-6 [9456 B]
Get:12 http://deb.debian.org/debian trixie/main amd64 libkrb5-3 amd64 1.21.3-5+deb13u1 [326 kB]
Get:13 http://deb.debian.org/debian trixie/main amd64 libgssapi-krb5-2 amd64 1.21.3-5+deb13u1 [138 kB]
Get:14 http://deb.debian.org/debian trixie/main amd64 libsasl2-modules-db amd64 2.1.28+dfsg1-9 [19.8 kB]
Get:15 http://deb.debian.org/debian trixie/main amd64 libsasl2-2 amd64 2.1.28+dfsg1-9 [57.5 kB]
Get:16 http://deb.debian.org/debian trixie/main amd64 libldap2 amd64 2.6.10+dfsg-1 [194 kB]
Get:17 http://deb.debian.org/debian trixie/main amd64 libnghttp2-14 amd64 1.64.0-1.1+deb13u1 [76.2 kB]
Get:18 http://deb.debian.org/debian trixie/main amd64 libnghttp3-9 amd64 1.8.0-1 [67.7 kB]
Get:19 http://deb.debian.org/debian trixie/main amd64 libpsl5t64 amd64 0.21.2-1.1+b1 [57.2 kB]
Get:20 http://deb.debian.org/debian trixie/main amd64 libp11-kit0 amd64 0.25.5-3 [425 kB]
Get:21 http://deb.debian.org/debian trixie/main amd64 libtasn1-6 amd64 4.20.0-2+deb13u1 [50.1 kB]
Get:22 http://deb.debian.org/debian trixie/main amd64 libgnutls30t64 amd64 3.8.9-3+deb13u4 [1469 kB]
Get:23 http://deb.debian.org/debian trixie/main amd64 librtmp1 amd64 2.4+20151223.gitfa8646d.1-2+b5 [58.8 kB]
Get:24 http://deb.debian.org/debian trixie/main amd64 libssh2-1t64 amd64 1.11.1-1+deb13u2 [245 kB]
Get:25 http://deb.debian.org/debian trixie/main amd64 libcurl4t64 amd64 8.14.1-2+deb13u5 [391 kB]
Get:26 http://deb.debian.org/debian trixie/main amd64 curl amd64 8.14.1-2+deb13u5 [270 kB]
Get:27 http://deb.debian.org/debian trixie/main amd64 libldap-common all 2.6.10+dfsg-1 [35.1 kB]
Get:28 http://deb.debian.org/debian trixie/main amd64 libsasl2-modules amd64 2.1.28+dfsg1-9 [66.7 kB]
Get:29 http://deb.debian.org/debian trixie/main amd64 publicsuffix all 20250328.1952-0.1 [296 kB]
[91mdebconf: unable to initialize frontend: Dialog
debconf: (TERM is not set, so the dialog frontend is not usable.)
debconf: falling back to frontend: Readline
[0m[91mdebconf: unable to initialize frontend: Readline
debconf: (Can't locate Term/ReadLine.pm in @INC (you may need to install the Term::ReadLine module) (@INC entries checked: /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.40.1 /usr/local/share/perl/5.40.1 /usr/lib/x86_64-linux-gnu/perl5/5.40 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl-base /usr/lib/x86_64-linux-gnu/perl/5.40 /usr/share/perl/5.40 /usr/local/lib/site_perl) at /usr/share/perl5/Debconf/FrontEnd/Readline.pm line 8, <STDIN> line 29.)
debconf: falling back to frontend: Teletype
[0m[91mdebconf: unable to initialize frontend: Teletype
debconf: (This frontend requires a controlling tty.)
debconf: falling back to frontend: Noninteractive
[0mFetched 5763 kB in 1s (5895 kB/s)
Selecting previously unselected package libunistring5:amd64.
(Reading database ... 
(Reading database ... 5%
(Reading database ... 10%
(Reading database ... 15%
(Reading database ... 20%
(Reading database ... 25%
(Reading database ... 30%
(Reading database ... 35%
(Reading database ... 40%
(Reading database ... 45%
(Reading database ... 50%
(Reading database ... 55%
(Reading database ... 60%
(Reading database ... 65%
(Reading database ... 70%
(Reading database ... 75%
(Reading database ... 80%
(Reading database ... 85%
(Reading database ... 90%
(Reading database ... 95%
(Reading database ... 100%
(Reading database ... 5644 files and directories currently installed.)
Preparing to unpack .../00-libunistring5_1.3-2_amd64.deb ...
Unpacking libunistring5:amd64 (1.3-2) ...
Selecting previously unselected package libidn2-0:amd64.
Preparing to unpack .../01-libidn2-0_2.3.8-2_amd64.deb ...
Unpacking libidn2-0:amd64 (2.3.8-2) ...
Selecting previously unselected package iputils-ping.
Preparing to unpack .../02-iputils-ping_3%3a20240905-3_amd64.deb ...
Unpacking iputils-ping (3:20240905-3) ...
Selecting previously unselected package linux-sysctl-defaults.
Preparing to unpack .../03-linux-sysctl-defaults_4.12.1_all.deb ...
Unpacking linux-sysctl-defaults (4.12.1) ...
Selecting previously unselected package bash-completion.
Preparing to unpack .../04-bash-completion_1%3a2.16.0-7_all.deb ...
Unpacking bash-completion (1:2.16.0-7) ...
Selecting previously unselected package krb5-locales.
Preparing to unpack .../05-krb5-locales_1.21.3-5+deb13u1_all.deb ...
Unpacking krb5-locales (1.21.3-5+deb13u1) ...
Selecting previously unselected package libbrotli1:amd64.
Preparing to unpack .../06-libbrotli1_1.1.0-2+b7_amd64.deb ...
Unpacking libbrotli1:amd64 (1.1.0-2+b7) ...
Selecting previously unselected package libkrb5support0:amd64.
Preparing to unpack .../07-libkrb5support0_1.21.3-5+deb13u1_amd64.deb ...
Unpacking libkrb5support0:amd64 (1.21.3-5+deb13u1) ...
Selecting previously unselected package libcom-err2:amd64.
Preparing to unpack .../08-libcom-err2_1.47.2-3+b12_amd64.deb ...
Unpacking libcom-err2:amd64 (1.47.2-3+b12) ...
Selecting previously unselected package libk5crypto3:amd64.
Preparing to unpack .../09-libk5crypto3_1.21.3-5+deb13u1_amd64.deb ...
Unpacking libk5crypto3:amd64 (1.21.3-5+deb13u1) ...
Selecting previously unselected package libkeyutils1:amd64.
Preparing to unpack .../10-libkeyutils1_1.6.3-6_amd64.deb ...
Unpacking libkeyutils1:amd64 (1.6.3-6) ...
Selecting previously unselected package libkrb5-3:amd64.
Preparing to unpack .../11-libkrb5-3_1.21.3-5+deb13u1_amd64.deb ...
Unpacking libkrb5-3:amd64 (1.21.3-5+deb13u1) ...
Selecting previously unselected package libgssapi-krb5-2:amd64.
Preparing to unpack .../12-libgssapi-krb5-2_1.21.3-5+deb13u1_amd64.deb ...
Unpacking libgssapi-krb5-2:amd64 (1.21.3-5+deb13u1) ...
Selecting previously unselected package libsasl2-modules-db:amd64.
Preparing to unpack .../13-libsasl2-modules-db_2.1.28+dfsg1-9_amd64.deb ...
Unpacking libsasl2-modules-db:amd64 (2.1.28+dfsg1-9) ...
Selecting previously unselected package libsasl2-2:amd64.
Preparing to unpack .../14-libsasl2-2_2.1.28+dfsg1-9_amd64.deb ...
Unpacking libsasl2-2:amd64 (2.1.28+dfsg1-9) ...
Selecting previously unselected package libldap2:amd64.
Preparing to unpack .../15-libldap2_2.6.10+dfsg-1_amd64.deb ...
Unpacking libldap2:amd64 (2.6.10+dfsg-1) ...
Selecting previously unselected package libnghttp2-14:amd64.
Preparing to unpack .../16-libnghttp2-14_1.64.0-1.1+deb13u1_amd64.deb ...
Unpacking libnghttp2-14:amd64 (1.64.0-1.1+deb13u1) ...
Selecting previously unselected package libnghttp3-9:amd64.
Preparing to unpack .../17-libnghttp3-9_1.8.0-1_amd64.deb ...
Unpacking libnghttp3-9:amd64 (1.8.0-1) ...
Selecting previously unselected package libpsl5t64:amd64.
Preparing to unpack .../18-libpsl5t64_0.21.2-1.1+b1_amd64.deb ...
Unpacking libpsl5t64:amd64 (0.21.2-1.1+b1) ...
Selecting previously unselected package libp11-kit0:amd64.
Preparing to unpack .../19-libp11-kit0_0.25.5-3_amd64.deb ...
Unpacking libp11-kit0:amd64 (0.25.5-3) ...
Selecting previously unselected package libtasn1-6:amd64.
Preparing to unpack .../20-libtasn1-6_4.20.0-2+deb13u1_amd64.deb ...
Unpacking libtasn1-6:amd64 (4.20.0-2+deb13u1) ...
Selecting previously unselected package libgnutls30t64:amd64.
Preparing to unpack .../21-libgnutls30t64_3.8.9-3+deb13u4_amd64.deb ...
Unpacking libgnutls30t64:amd64 (3.8.9-3+deb13u4) ...
Selecting previously unselected package librtmp1:amd64.
Preparing to unpack .../22-librtmp1_2.4+20151223.gitfa8646d.1-2+b5_amd64.deb ...
Unpacking librtmp1:amd64 (2.4+20151223.gitfa8646d.1-2+b5) ...
Selecting previously unselected package libssh2-1t64:amd64.
Preparing to unpack .../23-libssh2-1t64_1.11.1-1+deb13u2_amd64.deb ...
Unpacking libssh2-1t64:amd64 (1.11.1-1+deb13u2) ...
Selecting previously unselected package libcurl4t64:amd64.
Preparing to unpack .../24-libcurl4t64_8.14.1-2+deb13u5_amd64.deb ...
Unpacking libcurl4t64:amd64 (8.14.1-2+deb13u5) ...
Selecting previously unselected package curl.
Preparing to unpack .../25-curl_8.14.1-2+deb13u5_amd64.deb ...
Unpacking curl (8.14.1-2+deb13u5) ...
Selecting previously unselected package libldap-common.
Preparing to unpack .../26-libldap-common_2.6.10+dfsg-1_all.deb ...
Unpacking libldap-common (2.6.10+dfsg-1) ...
Selecting previously unselected package libsasl2-modules:amd64.
Preparing to unpack .../27-libsasl2-modules_2.1.28+dfsg1-9_amd64.deb ...
Unpacking libsasl2-modules:amd64 (2.1.28+dfsg1-9) ...
Selecting previously unselected package publicsuffix.
Preparing to unpack .../28-publicsuffix_20250328.1952-0.1_all.deb ...
Unpacking publicsuffix (20250328.1952-0.1) ...
Setting up libkeyutils1:amd64 (1.6.3-6) ...
Setting up libbrotli1:amd64 (1.1.0-2+b7) ...
Setting up libsasl2-modules:amd64 (2.1.28+dfsg1-9) ...
Setting up libnghttp2-14:amd64 (1.64.0-1.1+deb13u1) ...
Setting up krb5-locales (1.21.3-5+deb13u1) ...
Setting up libcom-err2:amd64 (1.47.2-3+b12) ...
Setting up libldap-common (2.6.10+dfsg-1) ...
Setting up libkrb5support0:amd64 (1.21.3-5+deb13u1) ...
Setting up libsasl2-modules-db:amd64 (2.1.28+dfsg1-9) ...
Setting up linux-sysctl-defaults (4.12.1) ...
Setting up bash-completion (1:2.16.0-7) ...
Setting up libp11-kit0:amd64 (0.25.5-3) ...
Setting up libunistring5:amd64 (1.3-2) ...
Setting up libk5crypto3:amd64 (1.21.3-5+deb13u1) ...
Setting up libsasl2-2:amd64 (2.1.28+dfsg1-9) ...
Setting up libnghttp3-9:amd64 (1.8.0-1) ...
Setting up libtasn1-6:amd64 (4.20.0-2+deb13u1) ...
Setting up libkrb5-3:amd64 (1.21.3-5+deb13u1) ...
Setting up libssh2-1t64:amd64 (1.11.1-1+deb13u2) ...
Setting up publicsuffix (20250328.1952-0.1) ...
Setting up libldap2:amd64 (2.6.10+dfsg-1) ...
Setting up libidn2-0:amd64 (2.3.8-2) ...
Setting up libgssapi-krb5-2:amd64 (1.21.3-5+deb13u1) ...
Setting up iputils-ping (3:20240905-3) ...
Setting up libgnutls30t64:amd64 (3.8.9-3+deb13u4) ...
Setting up libpsl5t64:amd64 (0.21.2-1.1+b1) ...
Setting up librtmp1:amd64 (2.4+20151223.gitfa8646d.1-2+b5) ...
Setting up libcurl4t64:amd64 (8.14.1-2+deb13u5) ...
Setting up curl (8.14.1-2+deb13u5) ...
Processing triggers for libc-bin (2.41-12) ...
 ---> Removed intermediate container c1f9ca218205
 ---> 4f494e2902da
Step 6/8 : RUN pip install --no-cache-dir -r requirements.txt
 ---> Running in ca9153f1b775
Collecting Flask==2.2.5
  Downloading Flask-2.2.5-py3-none-any.whl (101 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 101.8/101.8 kB 393.9 kB/s eta 0:00:00
Collecting Werkzeug==2.2.3
  Downloading Werkzeug-2.2.3-py3-none-any.whl (233 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 233.6/233.6 kB 304.9 kB/s eta 0:00:00
Collecting itsdangerous>=2.0
  Downloading itsdangerous-2.2.0-py3-none-any.whl (16 kB)
Collecting importlib-metadata>=3.6.0
  Downloading importlib_metadata-8.7.1-py3-none-any.whl (27 kB)
Collecting click>=8.0
  Downloading click-8.1.8-py3-none-any.whl (98 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 98.2/98.2 kB 79.7 kB/s eta 0:00:00
Collecting Jinja2>=3.0
  Downloading jinja2-3.1.6-py3-none-any.whl (134 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 134.9/134.9 kB 80.4 kB/s eta 0:00:00
Collecting MarkupSafe>=2.1.1
  Downloading markupsafe-3.0.4-cp39-cp39-manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_28_x86_64.whl (20 kB)
Collecting zipp>=3.20
  Downloading zipp-3.23.1-py3-none-any.whl (10 kB)
Installing collected packages: zipp, MarkupSafe, itsdangerous, click, Werkzeug, Jinja2, importlib-metadata, Flask
Successfully installed Flask-2.2.5 Jinja2-3.1.6 MarkupSafe-3.0.4 Werkzeug-2.2.3 click-8.1.8 importlib-metadata-8.7.1 itsdangerous-2.2.0 zipp-3.23.1
[91mWARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
[0m[91m
[notice] A new release of pip is available: 23.0.1 -> 26.0.1
[notice] To update, run: pip install --upgrade pip
[0m ---> Removed intermediate container ca9153f1b775
 ---> f75d5c743dd7
Step 7/8 : EXPOSE 5001
 ---> Running in 9f292939f51b
 ---> Removed intermediate container 9f292939f51b
 ---> 5b1069e18a82
Step 8/8 : CMD ["python", "app.py"]
 ---> Running in ddcbe067cc66
 ---> Removed intermediate container ddcbe067cc66
 ---> 1a0cda345794
Successfully built 1a0cda345794
Successfully tagged flask-api:latest
$ docker run -d --name mysql --net=my-bridge-net -e MYSQL_ROOT_PASSWORD=rootpassword mysql:latest
5a128d65ffd45a5e5ed36097c531c374c1a66a7e728e9d44dd1fbfb7bc20beb3
$ docker run -d --name redis --net=my-bridge-net redis:latest
152d2a5d85223a48f827ea59004fedeb7943799f4ac8c5a8a2ea1b29e8e46e01
$ docker run -d --name flask --net=my-bridge-net -p 5001:5001 flask-api
95515adbabe6604c731f65b8a08919bc17f8e690c67a50bc2c4e86322e94cf47
Waiting for containers to initialize...
$ docker ps
CONTAINER ID   IMAGE                                 COMMAND                  CREATED          STATUS          PORTS                                                                                                                                  NAMES
95515adbabe6   flask-api                             "python app.py"          6 seconds ago    Up 5 seconds    0.0.0.0:5001->5001/tcp, [::]:5001->5001/tcp                                                                                            flask
152d2a5d8522   redis:latest                          "docker-entrypoint.s…"   6 seconds ago    Up 5 seconds    6379/tcp                                                                                                                               redis
5a128d65ffd4   mysql:latest                          "docker-entrypoint.s…"   7 seconds ago    Up 6 seconds    3306/tcp, 33060/tcp                                                                                                                    mysql
cf0bd5c1fefc   gcr.io/k8s-minikube/kicbase:v0.0.51   "/usr/local/bin/entr…"   15 minutes ago   Up 15 minutes   127.0.0.1:32773->22/tcp, 127.0.0.1:32774->2376/tcp, 127.0.0.1:32775->5000/tcp, 127.0.0.1:32776->8443/tcp, 127.0.0.1:32777->32443/tcp   minikube

Testing Flask endpoint: http://localhost:5001/about
{
  "description": "This is a simple REST API built with Flask.",
  "name": "Simple REST API",
  "version": "1.0"
}


### Task 5: Test Connectivity
$ docker exec flask ping -c 3 mysql
PING mysql (172.18.0.2) 56(84) bytes of data.
64 bytes from mysql.my-bridge-net (172.18.0.2): icmp_seq=1 ttl=64 time=1.18 ms
64 bytes from mysql.my-bridge-net (172.18.0.2): icmp_seq=2 ttl=64 time=0.134 ms
64 bytes from mysql.my-bridge-net (172.18.0.2): icmp_seq=3 ttl=64 time=0.070 ms

--- mysql ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2025ms
rtt min/avg/max/mdev = 0.070/0.460/1.176/0.506 ms

$ docker exec flask ping -c 3 redis
PING redis (172.18.0.3) 56(84) bytes of data.
64 bytes from redis.my-bridge-net (172.18.0.3): icmp_seq=1 ttl=64 time=3.79 ms
64 bytes from redis.my-bridge-net (172.18.0.3): icmp_seq=2 ttl=64 time=0.075 ms
64 bytes from redis.my-bridge-net (172.18.0.3): icmp_seq=3 ttl=64 time=0.060 ms

--- redis ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2018ms
rtt min/avg/max/mdev = 0.060/1.308/3.791/1.755 ms

### Task 6: Clean up
$ docker stop mysql redis flask && docker rm mysql redis flask
mysql
redis
flask
mysql
redis
flask
$ docker network rm my-bridge-net
my-bridge-net

=== VERIFICATION SUCCESSFUL: Bridge Network, Multi-Containers, and Ping Passed ===
``


---

## Git Version Control & Push Verification

The terminal session log below confirms that this exercise was staged, committed, and pushed directly to the remote GitHub repository via the command line:

```bash
$ git status
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new directory: Exercise-04-Docker-Networking/

$ git add Exercise-04-Docker-Networking
$ git commit -m "Add Exercise-04-Docker-Networking"
[main 4188b70] Add Exercise-04-Docker-Networking
 4 files changed, 250 insertions(+)

$ git push origin main
Enumerating objects: 8, done.
Counting objects: 100% (8/8), done.
Delta compression using up to 16 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (7/7), 4.50 KiB | 4.50 MiB/s, done.
Total 7 (delta 2), reused 0 (delta 0), pack-reused 0
To https://github.com/Gsai442005/U.G.-Gagan-Sai-1BM23IS273-DEVOPS-.git
   main -> main
```
