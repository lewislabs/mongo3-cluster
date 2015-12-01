#!/bin/bash
echo "Running mongo-rs-setup.sh"

MONGODB1=`ping -c 1 mongo1 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
MONGODB2=`ping -c 1 mongo2 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
MONGODB3=`ping -c 1 mongo3 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`

echo "MONGO1=$MONGODB1"
echo "MONGO2=$MONGODB2"
echo "MONGO3=$MONGODB3"

echo "Waiting for startup on mongo1.."
until curl http://mongo1:28017/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 1
done

echo "Waiting for startup on mongo2.."
until curl http://mongo2:28017/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 1
done

echo "Waiting for startup on mongo3.."
until curl http://mongo3:28017/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 1
done

echo "Replicas started..."
mongo --host mongo1 <<EOF
    
   var cfg = {
        "_id": "rs",
        "version": 1,
        "members": [
            {
                "_id": 0,
                "host": "mongo1:27017",
                "priority": 2
            },
            {
                "_id": 1,
                "host": "mongo2:27017",
                "priority": 1
            },
            {
                "_id": 2,
                "host": "mongo3:27017",
                "priority": 1
            }
        ]
    };
    try{
        var config = rs.config();
        rs.reconfig(cfg, { force: true });
    }catch(err){
        rs.initiate(cfg);
    }    
EOF

