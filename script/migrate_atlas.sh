#! /bin/bash
bundle exec script/runner /Users/cmaitchison/Development/git/atlas/script/migrate_places_api.rb
while true; do
bundle exec script/runner /Users/cmaitchison/Development/git/atlas/script/migrate_pois_api.rb
MPID=$!
wait $MPID
done