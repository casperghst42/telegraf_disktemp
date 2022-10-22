FROM telegraf:latest

MAINTAINER casperghst42

RUN apt-get update && \
    apt-get install -yq \
    ipmitool smartmontools && \
# Cleanup
    apt-get clean && \
    rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

COPY --chmod=755 disktemp.sh /disktemp.sh
#COPY --chmod=755 entrypoint.sh /entrypoint.sh

#ENTRYPOINT ["/entrypoint.sh"]
CMD ["telegraf"]
