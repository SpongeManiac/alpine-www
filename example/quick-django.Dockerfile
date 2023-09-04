FROM alpine-www

#django app directory
VOLUME /django
#django static root
VOLUME /var/www/static

#requirements file name
ENV REQS=requirements.txt
#static files directory path inside of project
ENV STATIC_DIR=static
ENV AUTO_COLLECT=false

#expose port
EXPOSE 8080

#install dependencies
RUN apk add --update --no-cache rsync python3

#copy requirements.txt from current directory to root
ADD $REQS /

#change user
USER www-data

#ensure pip is installed & upgraded
RUN python3 -m ensurepip
RUN python3 -m pip install --no-cache --upgrade pip setuptools

#install dependencies from added requirements.txt
RUN python3 -m pip install -r /$REQS

#collect static files and run server
#using `python /django/manage.py collectstatic` returns a permission error. We will just use `rsync` instead.
CMD ["sh", "-c", "if $AUTO_COLLECT ; then rsync -rav /django/$STATIC_DIR/ /var/www/static/; fi; python3 /django/manage.py runserver 0.0.0.0:8080"]