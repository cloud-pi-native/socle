#!/bin/sh

now=`date +"%Y_%m_%d_%H%M%S"`
year=`date +"%Y"`
day=`date +"%d"`
month=`date +"%m"`



for f in /backup/*.pgdump; do
  if test -f "$f"; then
    echo "upload file $f to s3://$BUCKET_NAME/${f}-${now}"

    aws --no-verify-ssl s3 cp $f s3://$BUCKET_NAME/${f}-${now} --endpoint-url https://${BUCKET_HOST}:${BUCKET_PORT}

    fi
done

