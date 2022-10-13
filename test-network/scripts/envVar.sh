#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

source scriptUtils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/msp/tlscacerts/tlsca.coedinus.com-cert.pem
export PEER0_PETANI_CA=${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/tls/ca.crt
export PEER0_PENGEPUL_CA=${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/tls/ca.crt
export PEER0_DISTRIBUTOR_CA=${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/tls/ca.crt
export PEER0_RETAILER_CA=${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/tls/ca.crt


# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/msp/tlscacerts/tlsca.coedinus.com-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/ordererOrganizations/coedinus.com/users/Admin@coedinus.com/msp
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
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/petani.coedinus.com/users/Admin@petani.coedinus.com/msp
    export CORE_PEER_ADDRESS=peer0.petani.coedinus.com:7051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/tls/server.key
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="PengepulMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PENGEPUL_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/users/Admin@pengepul.coedinus.com/msp
    export CORE_PEER_ADDRESS=peer0.pengepul.coedinus.com:9051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/tls/server.key
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="DistributorMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_DISTRIBUTOR_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/distributor.coedinus.com/users/Admin@distributor.coedinus.com/msp
    export CORE_PEER_ADDRESS=peer0.distributor.coedinus.com:11051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/tls/server.key
   elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_LOCALMSPID="RetailerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_RETAILER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/retailer.coedinus.com/users/Admin@retailer.coedinus.com/msp
    export CORE_PEER_ADDRESS=peer0.retailer.coedinus.com:13051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/tls/server.key
  
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