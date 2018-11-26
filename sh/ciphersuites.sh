#!/bin/bash

openssl ciphers -V $1 | sort | awk -F" " '{printf "%9s %s %-35s %-10s %-20s %-15s %-20s %s\r\n", $1, $2, $3, $4, $5, $6, $7, $8}'
