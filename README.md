FishBase API
============

[![Build Status](https://travis-ci.org/ropensci/fishbaseapi.svg)](https://travis-ci.org/ropensci/fishbaseapi)

This is a volunteer effort from rOpenSci to provide a modern [RESTful API](http://en.wikipedia.org/wiki/Representational_state_transfer) to the backend SQL database behind the popular web resource, [fishbase.org](http://fishbase.org). The FishBase team have provided a snapshot of the database for our development purposes only and have expressed interest in hosting the finished API as a resource for all their users.

User quick start
----------------

At this time, this API is deployed for development purposes only.  The testing server may be available only intermittently and all endpoints are subject to change. Please check back here for updates when the API is officially released by FishBase.org. 

- The test API is being served from [fishbase.ropensci.org](http://fishbase.ropensci.org)
- Draft documentation of the API is available at [docs.fishbaseapi.apiary.io](http://docs.fishbaseapi.apiary.io/#)
- The [rfishbase2.0](https://github.com/ropensci/rfishbase/tree/rfishbase2.0) R package provides a convenient and powerful way to interact with the API.


Technical specifications
------------------------

### Quick start

- **Dependencies**: Any machine with Docker installed, see: [docs.docker.com/installation](http://docs.docker.com/installation)
- [Download](https://github.com/ropensci/fishbaseapi/archive/master.zip) or clone the fishbaseapi repository
- Place a snapshot of the FishBase SQL dump (not provided) in a file called `fbapp.sql` inside the downloaded directory.

- From that directory, run the `mysqp-helpers/import.sh` bash script, which will use Docker to import the dump into a MySQL docker container. This may take a while but needs only be done once.
- Run the `docker.sh` script to launch the API.  (Alternately, the containers can be launched with `fig up`, or using the `fleet` service files provided for the CoreOS architecture.)

### Technical overview

- The API is written in Ruby using the Sinatra Framework. Currently all API methods are defined in the `api.rb` file. The Dockerfile included here defines the runtime environment required, which is downloaded automatically from Docker Hub as the [ropensci/fishbaseapi](https://registry.hub.docker.com/u/ropensci/fishbaseapi/) container. 
- The API is served through a ruby unicorn server running behind a NGINX reverse proxy server (using the official Docker NGINX image). 
- The API sends queries to a separate, linked MySQL container (using the official Docker MySQL image).
- API queries are cached in a REDIS database provided by a linked REDIS container (again using an official Docker image)
- Logfiles can be collected, queried, and visualized using Logstash, ElasticSearch and Kibana respectively (still in development).

See the `docker.sh` script which orchestrates the linking and running of these separate containers. 

Design principles
-----------------

### RESTful design

The API implementation follows RESTful design.  Data is queried by means of `GET` requests to specific URL endpoints, e.g.

```
GET http://fishbaseapi.info/species/2
```

Or optionally, using particular queries

```
GET http://fishbaseapi.info/species?Genus=Labroides
```

```
GET http://fishbaseapi.info/species?Genus=Labroides&fields=Species
```

Queries return data in the JSON format. By default a limit of 10 entries matching the query are returned, though this can be configured by appending the `&limit=` option to the query URL. Simply visit any of these URLs in a browser for an example return object. 


### API Endpoints

The API design is to some extent constrained by the existing schema of the FishBase.org database.  At this time, endpoints correspond 1:1 with the tables of the database, and are named accordingly.  Future endpoints may provide more higher-level synthesis.  At this time, endpoints are implemented manually as time allows and existing use cases suggest; see [issue #2](https://github.com/ropensci/fishbaseapi/issues/2#issuecomment-73113433) for an overview. 

Richer processing of (some of) the endpoint returns can be done client-side, as illustrated in the (in-development) [rfishbase2.0](https://github.com/ropensci/rfishbase/tree/rfishbase2.0) R client for the API.

### Why Docker? 

Docker provides a fast and robust way to deploy all the necessary software required for the API on almost any platform. By using separate containers for the different services associated with the API, it becomes easier to scale the API across a cluster, isolate and diagnose points of failure. Individual containers providing services such as the MySQL database or REDIS cache can be restarted without disrupting other services of the API. 






