FROM ubuntu:22.04

# Systemd, Python va kerakli paketlarni o‘rnatish
RUN apt-get update && apt-get install -y \
    systemd python3 python3-venv python3-pip

# Ishchi katalog
WORKDIR /app

# Python skriptlarini konteynerga nusxalash
COPY server_2000.py server_2001.py server_2002.py server_2003.py /app/
COPY kali_server.py /app/kali_server.py
COPY server_8080 /app/server_8080
COPY ./myservice.service /etc/systemd/system/myservice.service

# Virtual muhit yaratish va kutubxonalarni o‘rnatish
RUN python3 -m venv /app/server_8080/env && \
    /app/server_8080/env/bin/pip install -r /app/server_8080/requirements.txt

# Systemd xizmatini yoqish
RUN systemctl enable myservice.service

# Portlarni ochish
EXPOSE 2000 2001 2002 2003 8080 9876

# ENTRYPOINT systemd orqali ishga tushirish
CMD ["/sbin/init"]
