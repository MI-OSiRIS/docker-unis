FROM python:3.6-stretch

MAINTAINER Ezra Kissel <ezkissel@indiana.edu>

EXPOSE 8888/tcp

RUN apt-get update
RUN apt-get -y install sudo mongodb redis-server python-setuptools python-pip python-m2crypto

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/unis && \
    echo "unis:x:${uid}:${gid}:Periscope UNIS,,,:/home/unis:/bin/bash" >> /etc/passwd && \
    echo "unis:x:${uid}:" >> /etc/group && \
    echo "unis ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/unis && \
    chmod 0440 /etc/sudoers.d/unis && \
    chown ${uid}:${gid} -R /home/unis

USER unis
ENV HOME /home/unis
WORKDIR $HOME

RUN git clone -b develop https://github.com/periscope-ps/unis
RUN cd unis && sudo python2 setup.py install && cd -

ADD run.sh .
CMD bash run.sh
