FROM ubuntu:22.04                                                                                                                            

# Ishchi katalogni yaratish
WORKDIR /app

# Kerakli fayllarni konteynerga ko'chirish
COPY server_2000.py server_2001.py server_2002.py server_2003.py kali_server.py /app/
COPY server_8080 /app/server_8080
COPY client_2004 /root/client_2004
COPY kali_server.py /root/kali_server.py

# Foydalanuvchi ruxsatlarini o‘rnatish
RUN chmod +x /root/client_2004

# Kerakli paketlarni o‘rnatish
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC \
    apt-get install -y python3 python3-venv python3-scapy python3-pip \
    systemd systemd-sysv ufw supervisor tzdata && \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update && apt-get install -y \
    nano vim iproute2 net-tools iputils-ping bridge-utils iptables socat netcat && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# **1. secureuser foydalanuvchisini yaratish**
RUN useradd -m -s /bin/bash secureuser

# **2. Katalog va fayllarga ruxsat berish**
RUN chown -R root:root /app /root
RUN chmod -R 700 /app /root  # Faqat root foydalanishi uchun ruxsatlar
RUN find /app -type f -exec chmod 700 {} \;

# **3. Scapy o'rnatish**
RUN pip install scapy

# **4. server_8080 uchun virtual muhit yaratish va kutubxonalarni o'rnatish**
RUN python3 -m venv /app/server_8080/env && \
    /app/server_8080/env/bin/pip install -r /app/server_8080/requirements.txt

# **5. Portlarni ochish**
EXPOSE 2000 2001 2002 2003 8080 9876

# **6. Root orqali xizmatlarni ishga tushirish**
CMD ["sh", "-c", "\
    python3 /app/server_2000.py & \
    python3 /app/server_2001.py & \
    python3 /app/server_2002.py & \
    python3 /app/server_2003.py & \
    python3 /app/kali_server.py & \
    /app/server_8080/env/bin/python3 /app/server_8080/manage.py runserver 0.0.0.0:8080 & \
    tail -f /dev/null"]
