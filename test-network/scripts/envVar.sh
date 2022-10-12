#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

source scriptUtils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/ceodinus.com/orderers/orderer.ceodinus.com/msp/tlscacerts/tlsca.ceodinus.com-cert.pem
export PEER0_PETANI_CA=${PWD}/organizations/peerOrganizations/petani.ceodinus.com/peers/peer0.petani.ceodinus.com/tls/ca.crt
export PEER0_PENGEPUL_CA=${PWD}/organizations/peerOrganizations/pengepul.ceodinus.com/peers/peer0.pengepul.ceodinus.com/tls/ca.crt
export PEER0_DISTRIBUTOR_CA=${PWD}/organizations/peerOrganizations/distributor.ceodinus.com/peers/peer0.distributor.ceodinus.com/tls/ca.crt
export PEER0_RETAILER_CA=${PWD}/organizations/peerOrganizations/retailer.ceodinus.com/peers/peer0.retailer.ceodinus.com/tls/ca.crt


# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/ordererOrganizations/ceodinus.com/orderers/orderer.ceodinus.com/msp/tlscacerts/tlsca.ceodinus.com-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/ordererOrganizations/ceodinus.com/users/Admin@ceodinus.com/msp
}

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="PetaniMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PETANI_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/petani.ceodinus.com/users/Admin@petani.ceodinus.com/msp
    export CORE_PEER_ADDRESS=peer0.petani.ceodinus.com:7051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/petani.ceodinus.com/peers/peer0.petani.ceodinus.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/petani.ceodinus.com/peers/peer0.petani.ceodinus.com/tls/server.key
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="PengepulMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PENGEPUL_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/pengepul.ceodinus.com/users/Admin@pengepul.ceodinus.com/msp
    export CORE_PEER_ADDRESS=peer0.pengepul.ceodinus.com:9051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/pengepul.ceodinus.com/peers/peer0.pengepul.ceodinus.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/pengepul.ceodinus.com/peers/peer0.pengepul.ceodinus.com/tls/server.key
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="DistributorMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_DISTRIBUTOR_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/distributor.ceodinus.com/users/Admin@distributor.ceodinus.com/msp
    export CORE_PEER_ADDRESS=peer0.distributor.ceodinus.com:11051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/distributor.ceodinus.com/peers/peer0.distributor.ceodinus.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/distributor.ceodinus.com/peers/peer0.distributor.ceodinus.com/tls/server.key
   elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_LOCALMSPID="RetailerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RETAILER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/retailer.ceodinus.com/users/Admin@retailer.ceodinus.com/msp
    export CORE_PEER_ADDRESS=peer0.retailer.ceodinus.com:13051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/retailer.ceodinus.com/peers/peer0.retailer.ceodinus.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/retailer.ceodinus.com/peers/peer0.retailer.ceodinus.com/tls/server.key
  
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {

  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.org$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}