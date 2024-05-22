#!/bin/bash

docker build -t sigidoc .
docker run -it -p 9999:9999 -v ~/Siegel:/sigidoc/webapps/ROOT/content/xml/epidoc -v ~/authority:/sigidoc/webapps/ROOT/content/xml/authority --rm --name sigidoc sigidoc
