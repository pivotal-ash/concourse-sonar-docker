FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/101/0/g' /usr/sbin/policy-rc.d
RUN apt-get update
RUN apt-get install -y iptables wget openssh-client postgresql postgresql-contrib

RUN mkdir /concourse
ADD ./concourse-start.sh /concourse/concourse-start.sh
ADD ./concourse-setup.sh /tmp/concourse-setup.sh
RUN /tmp/concourse-setup.sh

EXPOSE 8080

CMD ["/concourse/concourse-start.sh"]
