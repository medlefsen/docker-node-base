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
RUN /pd_build/utilities.sh
RUN /pd_build/nodejs.sh

RUN rm -f /etc/service/nginx/down

RUN npm install -g grunt-cli

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y imagemagick

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD webapp.conf /etc/nginx/sites-available/default

ONBUILD ADD . /home/app/webapp
ONBUILD RUN cd /home/app/webapp && npm install && grunt
ONBUILD RUN [ -e /home/app/webapp/nginx.conf ] && cp /home/app/webapp/nginx.conf /etc/nginx/main.d/app.conf
