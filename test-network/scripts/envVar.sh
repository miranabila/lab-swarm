#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

source scriptUtils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/msp/tlscacerts/tlsca.dinus.com-cert.pem
export PEER0_COE1_CA=${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/tls/ca.crt
export PEER0_COE2_CA=${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/tls/ca.crt
export PEER0_COE3_CA=${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/tls/ca.crt
export PEER0_COE4_CA=${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/tls/ca.crt


# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/msp/tlscacerts/tlsca.dinus.com-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/ordererOrganizations/dinus.com/users/Admin@dinus.com/msp
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
    export CORE_PEER_LOCALMSPID="Coe1Petani"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_COE1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/coe1.dinus.com/users/Admin@coe1.dinus.com/msp
    export CORE_PEER_ADDRESS=peer0.coe1.dinus.com:7051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/tls/server.key
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="Coe2Pengepul"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_COE2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/coe2.dinus.com/users/Admin@coe2.dinus.com/msp
    export CORE_PEER_ADDRESS=peer0.coe2.dinus.com:9051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/tls/server.key
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="Coe3Distributor"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_COE3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/coe3.dinus.com/users/Admin@coe3.dinus.com/msp
    export CORE_PEER_ADDRESS=peer0.coe3.dinus.com:11051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/tls/server.key
   elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_LOCALMSPID="Coe4Retailer"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_COE4_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/coe4.dinus.com/users/Admin@coe4.dinus.com/msp
    export CORE_PEER_ADDRESS=peer0.coe4.dinus.com:13051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/tls/server.key
  
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
    PEER="peer0.coe$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_COE$1_CA")
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