FROM mongo:3.0
COPY mongo-rs-setup.sh /
CMD /usr/bin/mongod --replSet rs --journal --smallfiles --fork --logpath /var/log/mongodb/mongod.log; /mongo-rs-setup.sh

