# functions file for network related stuff.

# function to get external IP address
function Get-MyExternalIP {
    $external_ip = (Invoke-WebRequest -UseBasicParsing -Uri "http://myexternalip.com/raw").content
    return $external_ip
}


# get my external IP info, save as an object
# expects the environment variable `$env:IPINFO_TOKEN` to be set with a valid token from ipinfo.io

# Should return results similar to this (json converted to custom object):
# ip             : x.x.x.x
# asn            : AS12345
# as_name        : SOME ISP NAME
# as_domain      : SOME ISP DOMAIN NAME
# country_code   : Country Code
# country        : Country Name
# continent_code : Continent Code
# continent      : Continent Name

function Get-MyExternalIPInfo {
    [CmdletBinding()]
    
    $external_ip_info = (Invoke-WebRequest -UseBasicParsing -Uri "https://api.ipinfo.io/lite/me?token=$env:IPINFO_TOKEN") | ConvertFrom-Json
    return $external_ip_info
}




