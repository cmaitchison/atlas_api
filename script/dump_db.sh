pg_dump -f tmp/lp_api.dump -b -c -h localhost -p 5432 -v -U postgres lp_api_dev
psql -d lp_api_dev -a -f lp_api_dev.dump