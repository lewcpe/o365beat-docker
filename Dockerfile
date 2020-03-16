FROM debian:stable-slim
MAINTAINER wason

RUN apt update && apt install -y curl
WORKDIR /tmp
RUN curl -s https://api.github.com/repos/counteractive/o365beat/releases/latest|grep "browser_download_url.*-amd64.deb" | grep -v "sha" | sed -r '/^\s*$/d'|cut -d "\"" -f 4 >dlurl.txt
RUN curl -L -O $(cat dlurl.txt)
RUN dpkg -i *.deb
RUN apt purge -y curl && rm *.deb && rm dlurl.txt

VOLUME ["/opt/o365beat/state"]
COPY o365beat.yml /etc/o365beat
ENTRYPOINT o365beat -e
