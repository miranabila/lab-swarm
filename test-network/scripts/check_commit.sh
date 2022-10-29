

echo "check commit readiness"
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CC_NAME --version 1 --sequence 1 --init-required --signature-policy "OR ('Coe1Petani.peer','Coe2Pengepul.peer','Coe3Distributor.peer','Coe4Retailer.peer')"   
