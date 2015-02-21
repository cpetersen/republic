#!/bin/sh
curl localhost:8000/routes -X POST -d '{"target": {"type": "rfc5424", "addr": "api.logentries.com:10000", "structured_data": "$1"}}'
