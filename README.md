# EDS-TEDS-Logs
Create log files of EDS and TEDS activity

## Docker

First get the source code:

```
git clone  --depth=1  https://github.com/rumachan/EDS-TEDS-Logs.git
```
Then build the docker image:

```
cd EDS-TEDS-Logs
docker build -t eds .
```
The resulting docker container has three mount points that have to be mounted
so the scripts can run:

* `/home/volcano/workdir`: stores output files that need to be persistent between runs
* `/home/volcano/sds`: contains the (read-only) GeoNet sds archive
* `/home/volcano/output`: stores output files for the website

Let's assume the following setup:

|Contents                  |Host directory                | Container directory |
|--------------------------|------------------------------|---------------------|
|Persistent work directory |/home/volcano/eds_teds_work/  |/home/volcano/workdir|
|GeoNet SDS archive        |/geonet/seismic/sds           |/home/volcano/sds    |
|Output for web server     |/var/www/html/geonet_wiki_data|/home/volcano/output |

Then you can create a container and run the `tedslog_2.csh` script for the first time as follows:

```
docker run --name teds -it -v /geonet/seismic/sds:/home/volcano/sds \
-v /var/www/html/geonet_wiki_data:/home/volcano/output \
-v /home/volcano/eds_teds_work:/home/volcano/workdir  eds /bin/csh tedslog_2.csh
```
Afterwards you will only have to start the container:
```
docker start teds
```
In the same way you can create containers for the `edslog_1.csh` and `edslog_2.csh` scripts.
