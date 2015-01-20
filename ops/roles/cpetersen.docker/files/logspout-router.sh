#!/bin/sh
curl localhost:8000/routes -X POST -d '{"target": {"type": "rfc5424", "addr": "api.logentries.com:10000", "structured_data": "e111fb1e-3d4d-44b5-a61a-8fa6c610cdf8"}}'
