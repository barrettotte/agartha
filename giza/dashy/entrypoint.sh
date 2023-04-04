#!/bin/sh

# inject admin credentials into dashy config

set -e

dashy_config=/app/public/conf.yml
tmp_config=/tmp-dashy-config.yml

echo "injecting admin credentials"

# sed -i replaces inode of file, need to copy original instead. docker mount doesn't allow inode change
cp $dashy_config $tmp_config

sed -i "s/\$DASHY_ADMIN_USER/$DASHY_ADMIN_USER/g" $tmp_config
sed -i "s/\$DASHY_ADMIN_PASSWORD_SHA256/$DASHY_ADMIN_PASSWORD_SHA256/g" $tmp_config

cat $tmp_config > $dashy_config
rm $tmp_config

# run original entrypoint
yarn start
