#!/bin/bash
echo "Running mongo-rs-setup.sh"
echo "Grabbing the IP's for the other mongo servers"
MONGODB2=`ping -c 1 mongo2 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
MONGODB3=`ping -c 1 mongo3 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`

echo "Waiting for startup on mongo3.."
until curl http://${MONGODB3}:28017/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 1
done

echo "Waiting for startup on mongo2.."
until curl http://${MONGODB2}:28017/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 1
done

echo "Replicas started..."
mongo <<EOF
    
   var cfg = {
        "_id": "rs",
        "version": 1,
        "members": [
            {
                "_id": 0,
                "host": "127.0.0.1:27017",
                "priority": 2
            },
            {
                "_id": 1,
                "host": "${MONGODB2}:27017",
                "priority": 0
            },
            {
                "_id": 2,
                "host": "${MONGODB3}:27017",
                "priority": 0
            }
        ]
    };
    if(rs.config().ok>0){
        rs.reconfig(cfg, { force: true });
    }else{
        rs.initiate(cfg);
    }    
EOF

