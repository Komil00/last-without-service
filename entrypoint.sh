#!/bin/bash
set -m

# Oddiy jarayonlarni ishga tushirish
python3 /app/server_2000.py --port 2000 &
python3 /app/server_2001.py --port 2001 &
python3 /app/server_2002.py --port 2002 &
python3 /app/server_2003.py --port 2003 &
python3 /app/kali_server.py &

# Systemd bilan bosh service ishga tushirish
exec /sbin/init
