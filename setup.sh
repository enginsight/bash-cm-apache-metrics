    #
#   # #   Enginsight GmbH
# # # #   Geschäftsführer: Mario Jandeck, Eric Range
# #   #   Hans-Knöll-Straße 6, 07745 Jena
  #
  
# PLEASE READ ME!
# You need to enable "mod_status".
# See https://httpd.apache.org/docs/2.4/mod/mod_status.html for details:

server_status_url="https://enginsight.com/server-status"

server_status=`curl -s $server_status_url | tr '\n' ' '`
requests_per_second="([0-9\.]+) requests\/sec"
requests_being_processed="([0-9\.]+) requests currently being processed"
idle_workers="([0-9\.]+) idle workers"

if [[ $server_status =~ $requests_per_second ]]; then
  apache_requests_per_second=`awk "BEGIN {print (${BASH_REMATCH[1]})}"`
fi

if [[ $server_status =~ $requests_being_processed ]]; then
  apache_requests_being_processed=`awk "BEGIN {print (${BASH_REMATCH[1]})}"`
fi

if [[ $server_status =~ $idle_workers ]]; then
  apache_idle_workers=`awk "BEGIN {print (${BASH_REMATCH[1]})}"`
fi

cat << EOF
__METRICS__={
  "apache_requests_per_second": ${apache_requests_per_second:-0},
  "apache_requests_being_processed": ${apache_requests_being_processed:-0},
  "apache_idle_workers": ${apache_idle_workers:-0}
}
EOF
