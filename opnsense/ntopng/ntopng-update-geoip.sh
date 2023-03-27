#!/bin/sh

set -eu
mkdir -p "/usr/local/share/ntopng/httpdocs/geoip"

maxmind_license=LICENSE
maxmind_base=https://download.maxmind.com/app/geoip_download

# fetch geo ip data and place in ntopng directory; args: $1 URL, $2 output file name
_fetch() {
    url="$1"
    out="$2"
    temp_file="$(mktemp "/usr/local/share/ntopng/httpdocs/geoip/GeoIP.dat-XXXXXX")"
    trap 'rc=$? ; set +e ; rm -f "'"$temp_file"'" ; exit $rc' 0
    if fetch -o - "$url" | tar -x --strip-components 1 -f - "*/$out" >> "$temp_file" ; then
        chmod 444 "$temp_file"
        if ! mv -f "$temp_file" "/usr/local/share/ntopng/httpdocs/geoip/$2" ; then
            echo "Unable to replace /usr/local/share/ntopng/httpdocs/geoip/$2"
            return 2
        fi
    else
        echo "$2 download failed"
        return 1
    fi
    rm -f "$temp_file"
    trap - 0
    return 0
}

chmod +x /usr/local/opnsense/scripts/OPNsense/Ntopng/generate_certs.php

echo Fetching GeoLite2-City.tar.gz...
_fetch "$maxmind_base?edition_id=GeoLite2-City&license_key=$maxmind_license&suffix=tar.gz" GeoLite2-City.mmdb

echo Fetching GeoLite2-Country.tar.gz...
_fetch "$maxmind_base?edition_id=GeoLite2-Country&license_key=$maxmind_license&suffix=tar.gz" GeoLite2-Country.mmdb

echo Fetching GeoLite2-ASN.tar.gz...
_fetch "$maxmind_base?edition_id=GeoLite2-ASN&license_key=$maxmind_license&suffix=tar.gz" GeoLite2-ASN.mmdb
