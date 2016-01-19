## re-build:
# docker tag bjoernr/voctogui:latest bjoernr/voctogui:old; docker build -t bjoernr/voctogui ./voctogui-docker && docker rmi bjoernr/voctogui:old
## build:
# docker build -t bjoernr/voctogui ./voctogui-docker
## run:
# need container mappings!!
# gui will connect to "corehost": corehost is aliased to container "voctocore"
# docker run -it --rm --env=gid=$(id -g) --env=uid=$(id -u) --env=DISPLAY=$DISPLAY --link=voctocore:corehost -v /tmp/.X11-unix:/tmp/.X11-unix -v /tmp/.docker.xauth:/tmp/.docker.xauth bjoernr/voctogui

FROM ubuntu:wily

MAINTAINER Bjoern Riemer <bjoern.riemer@web.de>

ENV DEBIAN_FRONTEND noninteractive

ENV uid 1000
ENV gid 1000

RUN useradd -m voc

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		gstreamer1.0-plugins-bad gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
		gstreamer1.0-plugins-ugly gstreamer1.0-tools libgstreamer1.0-0 python3 python3-gi gir1.2-gstreamer-1.0 \
	&& apt-get install -y git wget \
	&& apt-get clean

RUN wget -q https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 -O /bin/gosu && chmod +x /bin/gosu
RUN cd /opt && git clone https://github.com/voc/voctomix.git

RUN apt-get update \
	&& apt-get install -y gir1.2-gst-plugins-base-1.0 gir1.2-gstreamer-1.0 gir1.2-gtk-3.0 \
	&& apt-get clean

COPY start-voctogui.sh /opt/start-voctogui.sh
COPY config-gui.ini /opt/voctomix/voctogui/config.ini

CMD /opt/start-voctogui.sh