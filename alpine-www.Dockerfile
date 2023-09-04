FROM alpine

#install dependencies
RUN apk add --update --no-cache shadow

#perform groupmod/usermod magic to make www-data user have uid:gid of 33:33

#change xfs gid (X Font Server)
RUN groupmod -g 32 xfs
#change xfs uid + gid
RUN usermod -u 32 -g 32 xfs
#change www-data gid
RUN groupmod -g 33 www-data
#add www-data user (-S = System user, -D = no password, -h = home dir, -g = GECOS, -u = uid, -G = in group)
RUN adduser -S -D -h /var/www -g "www-data" -u 33 www-data -G www-data