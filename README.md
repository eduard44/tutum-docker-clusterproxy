tutum-docker-clusterproxy
=========================

HAproxy image that balances between linked containers and, if launched in Tutum, 
reconfigures itself when a linked cluster member joins or leaves

**Fork notes:**
This fork is modified to download the SSL certificate file from S3 rather than using an environment variable. The environment variables required are explained below.

Usage
-----

Make sure your application container exposes port 80. Then, launch it:

	docker run -d --name web1 tutum/hello-world
	docker run -d --name web2 tutum/hello-world

Then, run tutum/haproxy-http linking it to the target containers:

	docker run -d -p 80:80 --link web1:web1 --link web2:web2 -e "AWS_CLIENT_KEY_ID=XXXXXX" -e "AWS_SECRET_ACCESS_KEY=XXXXXX" -e "S3_SSL_CERT_FILE=s3://mybucket/mycert.pem" eduard44/tutum-docker-clusterproxy
	
Usage within Tutum
------------------

Launch your applicaiton within Tutum's web interface.

Then, launch another application with tutum/haproxy which is linked to the application cluster created earlier, and with "Full Access" API role (or other appropiate read-only role).

That's it - the proxy container will start querying Tutum's API for an updated list of application cluster members and reconfigure itself automatically.

Configuration
-------------

You can overwrite the following HAproxy configuration options:

* `PORT` (default: `80`): Port HAproxy will bind to, and the port that will forward requests to.
* `MODE` (default: `http`): Mode of load balancing for HAproxy. Possible values include: `http`, `tcp`, `health`.
* `BALANCE` (default: `roundrobin`): Load balancing algorithm to use. Possible values include: `roundrobin`, `static-rr`, `source`, `leastconn`.
* `MAXCONN` (default: `4096`): Sets the maximum per-process number of concurrent connections.
* `OPTIONS` (default: `redispatch`): Comma-separated list of HAproxy `option` entries to the `default` section.
* `TIMEOUTS` (default: `connect 5000,client 50000,server 50000`): Comma-separated list of HAproxy `timeout` entries to the `default` section.
* ~~`SSL_CERT` (default:  `**None**`): An optional certificate to use on the binded port. It should have both the private and public keys content. If using it for HTTPS, remember to also set `PORT=443` as the port is not changed by this setting.~~

Fork-specific variables:
* `AWS_CLIENT_KEY_ID`: The AWS client ID
* `AWS_ACCESS_ACCESS_KEY`: The AWS client secret
* `S3_SSL_CERT_FILE`: Path to the pem file on S3. It must be in AWS CLI format: `s3://mybucket/mycert.pem`

Check [the HAproxy configuration manual](http://haproxy.1wt.eu/download/1.4/doc/configuration.txt) for more information on the above.
