FROM mongo:3.0
EXPOSE 28017
ENTRYPOINT /usr/bin/mongod --replSet rs --journal --rest --smallfiles --logpath /var/log/mongodb/mongod.log