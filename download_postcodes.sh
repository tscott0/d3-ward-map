#!/bin/bash
set -e

MAX_ITERATIONS=20
PAGE_OFFSET=0

for i in `seq 1 ${MAX_ITERATIONS}`;
do
    OUTFILE=postcodes${i}.json
    echo -e "\nDownloading ${OUTFILE}\n"

    wget -O ${OUTFILE} "https://ons-inspire.esriuk.com/arcgis/rest/services/Postcodes/ONS_Postcode_Directory_Latest_Centroids/MapServer/0/query?where=1%3D1&outFields=pcd,pcd2,pcds,lat,long,osward&geometry=-0.77%2C51.332%2C0.605%2C51.631&geometryType=esriGeometryEnvelope&inSR=4326&spatialRel=esriSpatialRelIntersects&outSR=4326&resultOffset=${PAGE_OFFSET}&f=geojson"

    POSTCODES_FOUND=$(cat ${OUTFILE} | jq '.features | length') 
    PAGE_OFFSET=$((${PAGE_OFFSET} + ${POSTCODES_FOUND}))

    echo -e "\n${OUTFILE} contains ${POSTCODES_FOUND} postcodes. Offset= ${PAGE_OFFSET}"

    MORE_PAGES=$(cat ${OUTFILE} | jq '.exceededTransferLimit')

    if [ "${MORE_PAGES}" != "true" ]; then
        exit 0
    fi
done 