FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/101/0/g' /usr/sbin/policy-rc.d
RUN apt-get update
RUN apt-get install -y iptables wget openssh-client postgresql postgresql-contrib

ADD ./concourse /concourse
RUN /concourse/setup.sh

EXPOSE 8080

CMD ["/concourse/start.sh"]
