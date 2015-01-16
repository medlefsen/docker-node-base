FROM phusion/passenger-customizable
MAINTAINER Matt Edlefsen <matt.edlefsen@gmail.com>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features. Uncomment the features you want:
#
#   Build system and git.
RUN /build/utilities.sh
#   Ruby support.
#RUN /build/ruby1.9.sh
#RUN /build/ruby2.0.sh
#RUN /build/ruby2.1.sh
#   Python support.
#RUN /build/python.sh
#   Node.js and Meteor support.
RUN /build/nodejs.sh
RUN /build/redis.sh

RUN rm -f /etc/service/redis/down
RUN rm -f /etc/service/nginx/down

RUN npm install -g grunt-cli

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD webapp.conf /etc/nginx/sites-available/default

ONBUILD ADD . /home/app/webapp
ONBUILD RUN cd /home/app/webapp && npm install && grunt
