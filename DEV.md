# Development

Configuration and steps for testing converter modules & profiles.

## Preliminary setup

Run the preliminary setup run when first using or switching to a config.

```bash
docker run --name mongo -d -p 27017:27017 mongo:3.2 || true
bundle exec rake db:nuke
bundle exec rake cache:download_vocabularies
bundle exec rake cache:export[~/.cspace-converter,cache.csv]
```

## Core

Config:

```txt
# DEVELOPMENT .env.local
export CSPACE_CONVERTER_DB_HOST=127.0.0.1
export CSPACE_CONVERTER_BASE_URI=https://core.dev.collectionspace.org/cspace-services
export CSPACE_CONVERTER_DOMAIN=core.collectionspace.org
export CSPACE_CONVERTER_LOG_LEVEL=debug
export CSPACE_CONVERTER_MODULE=Core
export CSPACE_CONVERTER_USERNAME=admin@core.collectionspace.org
export CSPACE_CONVERTER_PASSWORD=Administrator
```

Steps:

```bash
./reset.sh # make sure we're empty
./bin/rake remote:get[media] # test connection

./import.sh data/core/sample_data_acquisition_core_all.csv acquisition1 acquisition
./remote.sh transfer CollectionObject acquisition1
./remote.sh delete CollectionObject acquisition1

./import.sh data/core/sample_data_cataloging_core_excerpt.csv cataloging1 cataloging
./remote.sh transfer CollectionObject cataloging1
./remote.sh delete CollectionObject cataloging1

./import.sh data/core/sample_data_mediahandling_core_all.csv media1 media
./remote.sh transfer Media media1
./remote.sh delete Media media1
```

## Anthro

Config:

```txt
# DEVELOPMENT .env.local
export CSPACE_CONVERTER_DB_HOST=127.0.0.1
export CSPACE_CONVERTER_BASE_URI=https://anthro.dev.collectionspace.org/cspace-services
export CSPACE_CONVERTER_DOMAIN=anthro.collectionspace.org
export CSPACE_CONVERTER_LOG_LEVEL=debug
export CSPACE_CONVERTER_MODULE=Anthro
export CSPACE_CONVERTER_USERNAME=admin@anthro.collectionspace.org
export CSPACE_CONVERTER_PASSWORD=Administrator
```

Steps:

```bash
./reset.sh # make sure we're empty
./bin/rake remote:get[claims] # test connection

./import.sh data/anthro/$TODO.csv claims1 nagpra
./remote.sh transfer Nagpra claims1
./remote.sh delete Nagpra claims1
```

## Materials

Config:

```txt
# DEVELOPMENT .env.local
export CSPACE_CONVERTER_DB_HOST=127.0.0.1
export CSPACE_CONVERTER_BASE_URI=https://materials.dev.collectionspace.org/cspace-services
export CSPACE_CONVERTER_DOMAIN=materials.collectionspace.org
export CSPACE_CONVERTER_LOG_LEVEL=debug
export CSPACE_CONVERTER_MODULE=Materials
export CSPACE_CONVERTER_USERNAME=admin@materials.collectionspace.org
export CSPACE_CONVERTER_PASSWORD=Administrator
```

Steps:

```bash
./reset.sh # make sure we're empty
./bin/rake remote:get[media] # test connection

./import.sh data/core/sample_data_mediahandling_core_all.csv media1 media
./remote.sh transfer Media media1
./remote.sh delete Media media1
```
