# About
`alpine-www` is a modified `alpine` image that provides the `www-data` user with the usual `33:33` user id and group id instead of the `alpine` default `82:82`. This allows the image to be ran as the `www-data` user without any permission conflicts. `shadow` is installed as a dependency, which adds about 2MB to the `alpine` image for a total image size of about 9.5MB. To accomplish this task, the `xfs` (X Font Server) user and group id was changed from `33:33` to `32:32`.

# Use
Pull the image:
`docker pull spongemaniac/alpine-www`

and extend from this image like any other:
```
FROM spongemaniac/alpine-www

...
```

# Source
`alpine-www` is a simple modification of the official `alpine` image:
```Dockerfile
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
```
