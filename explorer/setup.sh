export PETANI_MSPKEY=$(cd ../test-network/organizations/peerOrganizations/petani.coedinus.com/users/Admin@petani.coedinus.com/msp/keystore && ls *_sk) 


sed -i  "s/PETANI_MSPKEY/$PETANI_MSPKEY/g" first-network.json 