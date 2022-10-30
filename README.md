# telegraf_disktemp
Using inputs.exec to grab disk temperature.

This is based on something I saw on reddit, and most of the code is a rip-off.

Change this "DISKS=$(ls /dev/sd?)" in disktemp.sh to include the disks you want to include.

It will collect information like this:
```
exec_disktemp,capacity=bytes,disk=/dev/sda,host=telegraf2,model=WDC\ WD101EFAX-68LDBN0,serial=12345678 temperature=38 < timestamp >
```

### To use

#### docker-compose
```
telegraf2:
    container_name: telegraf2
    hostname: telegraf2
    image: casperghst42/telegraf
    restart: unless-stopped
    user: root:root
    networks:
       mynetwork:
    volumes:
       - '/etc/localtime:/etc/localtime:ro'
       - '/etc/timezone:/etc/timezone:ro'
       - './data/telegraf.conf:/etc/telegraf/telegraf.conf:ro'
```
#### telegraf.conf
```
[[inputs.exec]]
    name_suffix = "_disktemp"
    timeout = "5s"
    interval = "15s"
    data_format = "json"
    tag_keys = ["disk", "model", "serial", "capacity"]
    commands = [
      "/bin/bash /disktemp.sh",
    ]
```
