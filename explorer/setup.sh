export COE1_MSPKEY=$(cd ../test-network/organizations/peerOrganizations/coe1.dinus.com/users/Admin@coe1.dinus.com/msp/keystore && ls *_sk) 


sed -i  "s/COE1_MSPKEY/$COE1_MSPKEY/g" first-network.json 