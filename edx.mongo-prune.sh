#------------------------------------------------------------------
# written by: McDaniel
# date: apr-2020
#
# usage: Python3 script to delete orphaned JSON documents from MongoDb edxapp
#
#     source ~./venv/bin/activate
#     ./structures.sh
#
# see:
#  - https://discuss.openedx.org/t/mongo-how-to-prune-delete-orphaned-course-data/1811/2
#  - https://github.com/edx/tubular/blob/master/scripts/structures.py
#
# sample Mongo command-line connection string:
#    mongo --port 27017 -u "admin" -p "<MONGODB ADMIN PASSWORD>"  --authenticationDatabase "admin"
#
# MongoDb connection string format:
#    "mongodb://myDBReader:D1fficultP%40ssw0rd@mongodb0.example.com:27017/?authSource=admin"
#    "mongodb://edxapp:password@edx.devstack.mongo/edxapp"
#
#    "mongodb://edxapp:<MONGODB ADMIN PASSWORD>@localhost:27017/?authSource=admin"
#------------------------------------------------------------------

## This generates the plan
structures.py --connection="mongodb://admin:<MONGODB ADMIN PASSWORD>@localhost:27017/?authSource=admin" \
  --database-name edxapp \
  make_plan \
  -v DEBUG out.json \
  --details details.txt \
  --retain 5

### This performs the prune
structures.py --connection="mongodb://admin:<MONGODB ADMIN PASSWORD>@localhost:27017/?authSource=admin" \
  --database-name edxapp \
                prune  out.json