#!/bin/bash

source scriptUtils.sh
export PATH=${PWD}/../bin:$PATH
function createCoe1() {
  mkdir channel-artifacts
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/coe1.dinus.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/coe1.dinus.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-coe1 --tls.certfiles ${PWD}/organizations/fabric-ca/coe1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-coe1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-coe1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-coe1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-coe1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/coe1.dinus.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-coe1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/coe1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-coe1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/coe1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-coe1 --id.name coe1admin --id.secret coe1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/coe1/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/coe1.dinus.com/peers
  mkdir -p organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-coe1 -M ${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/msp --csr.hosts peer0.coe1.dinus.com --tls.certfiles ${PWD}/organizations/fabric-ca/coe1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe1.dinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-coe1 -M ${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/tls --enrollment.profile tls --csr.hosts peer0.coe1.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/coe1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/coe1.dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/coe1.dinus.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/coe1.dinus.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/coe1.dinus.com/tlsca/tlsca.coe1.dinus.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/coe1.dinus.com/ca
  cp ${PWD}/organizations/peerOrganizations/coe1.dinus.com/peers/peer0.coe1.dinus.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/coe1.dinus.com/ca/ca.coe1.dinus.com-cert.pem

  mkdir -p organizations/peerOrganizations/coe1.dinus.com/users
  mkdir -p organizations/peerOrganizations/coe1.dinus.com/users/User1@coe1.dinus.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-coe1 -M ${PWD}/organizations/peerOrganizations/coe1.dinus.com/users/User1@coe1.dinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/coe1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe1.dinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/coe1.dinus.com/users/User1@coe1.dinus.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/coe1.dinus.com/users/Admin@coe1.dinus.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://coe1admin:coe1adminpw@localhost:7054 --caname ca-coe1 -M ${PWD}/organizations/peerOrganizations/coe1.dinus.com/users/Admin@coe1.dinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/coe1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe1.dinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/coe1.dinus.com/users/Admin@coe1.dinus.com/msp/config.yaml

}

function createCoe2() {
  mkdir channel-artifacts
  mkdir -p organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/msp/tlscacerts/
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/coe2.dinus.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/coe2.dinus.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-coe2 --tls.certfiles ${PWD}/organizations/fabric-ca/coe2/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-coe2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-coe2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-coe2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-coe2.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/coe2.dinus.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-coe2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/coe2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-coe2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/coe2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-coe2 --id.name coe2admin --id.secret coe2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/coe2/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/coe2.dinus.com/peers
  mkdir -p organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-coe2 -M ${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/msp --csr.hosts peer0.coe2.dinus.com --tls.certfiles ${PWD}/organizations/fabric-ca/coe2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe2.dinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-coe2 -M ${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/tls --enrollment.profile tls --csr.hosts peer0.coe2.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/coe2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/coe2.dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/coe2.dinus.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/coe2.dinus.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/coe2.dinus.com/tlsca/tlsca.coe2.dinus.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/coe2.dinus.com/ca
  cp ${PWD}/organizations/peerOrganizations/coe2.dinus.com/peers/peer0.coe2.dinus.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/coe2.dinus.com/ca/ca.coe2.dinus.com-cert.pem

  mkdir -p organizations/peerOrganizations/coe2.dinus.com/users
  mkdir -p organizations/peerOrganizations/coe2.dinus.com/users/User1@coe2.dinus.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-coe2 -M ${PWD}/organizations/peerOrganizations/coe2.dinus.com/users/User1@coe2.dinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/coe2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe2.dinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/coe2.dinus.com/users/User1@coe2.dinus.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/coe2.dinus.com/users/Admin@coe2.dinus.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://coe2admin:coe2adminpw@localhost:8054 --caname ca-coe2 -M ${PWD}/organizations/peerOrganizations/coe2.dinus.com/users/Admin@coe2.dinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/coe2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe2.dinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/coe2.dinus.com/users/Admin@coe2.dinus.com/msp/config.yaml

}



function createCoe3() {
  mkdir channel-artifacts
  mkdir -p organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/msp/tlscacerts/
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/coe3.dinus.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/coe3.dinus.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-coe3 --tls.certfiles ${PWD}/organizations/fabric-ca/coe3/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-coe3.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-coe3.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-coe3.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-coe3.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/coe3.dinus.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-coe3 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/coe3/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-coe3 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/coe3/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-coe3 --id.name coe3admin --id.secret coe3adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/coe3/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/coe3.dinus.com/peers
  mkdir -p organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-coe3 -M ${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/msp --csr.hosts peer0.coe3.dinus.com --tls.certfiles ${PWD}/organizations/fabric-ca/coe3/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe3.dinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-coe3 -M ${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/tls --enrollment.profile tls --csr.hosts peer0.coe3.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/coe3/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/coe3.dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/coe3.dinus.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/coe3.dinus.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/coe3.dinus.com/tlsca/tlsca.coe3.dinus.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/coe3.dinus.com/ca
  cp ${PWD}/organizations/peerOrganizations/coe3.dinus.com/peers/peer0.coe3.dinus.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/coe3.dinus.com/ca/ca.coe3.dinus.com-cert.pem

  mkdir -p organizations/peerOrganizations/coe3.dinus.com/users
  mkdir -p organizations/peerOrganizations/coe3.dinus.com/users/User1@coe3.dinus.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca-coe3 -M ${PWD}/organizations/peerOrganizations/coe3.dinus.com/users/User1@coe3.dinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/coe3/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe3.dinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/coe3.dinus.com/users/User1@coe3.dinus.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/coe3.dinus.com/users/Admin@coe3.dinus.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://coe3admin:coe3adminpw@localhost:9054 --caname ca-coe3 -M ${PWD}/organizations/peerOrganizations/coe3.dinus.com/users/Admin@coe3.dinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/coe3/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe3.dinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/coe3.dinus.com/users/Admin@coe3.dinus.com/msp/config.yaml

}


function createCoe4() {
  mkdir channel-artifacts
  mkdir -p organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/msp/tlscacerts/
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/coe4.dinus.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/coe4.dinus.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-coe4 --tls.certfiles ${PWD}/organizations/fabric-ca/coe4/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-coe4.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-coe4.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-coe4.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-coe4.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/coe4.dinus.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-coe4 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/coe4/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-coe4 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/coe4/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-coe4 --id.name coe4admin --id.secret coe4adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/coe4/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/coe4.dinus.com/peers
  mkdir -p organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-coe4 -M ${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/msp --csr.hosts peer0.coe4.dinus.com --tls.certfiles ${PWD}/organizations/fabric-ca/coe4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe4.dinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-coe4 -M ${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/tls --enrollment.profile tls --csr.hosts peer0.coe4.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/coe4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/coe4.dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/coe4.dinus.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/coe4.dinus.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/coe4.dinus.com/tlsca/tlsca.coe4.dinus.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/coe4.dinus.com/ca
  cp ${PWD}/organizations/peerOrganizations/coe4.dinus.com/peers/peer0.coe4.dinus.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/coe4.dinus.com/ca/ca.coe4.dinus.com-cert.pem

  mkdir -p organizations/peerOrganizations/coe4.dinus.com/users
  mkdir -p organizations/peerOrganizations/coe4.dinus.com/users/User1@coe4.dinus.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-coe4 -M ${PWD}/organizations/peerOrganizations/coe4.dinus.com/users/User1@coe4.dinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/coe4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe4.dinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/coe4.dinus.com/users/User1@coe4.dinus.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/coe4.dinus.com/users/Admin@coe4.dinus.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://coe4admin:coe4adminpw@localhost:11054 --caname ca-coe4 -M ${PWD}/organizations/peerOrganizations/coe4.dinus.com/users/Admin@coe4.dinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/coe4/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/coe4.dinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/coe4.dinus.com/users/Admin@coe4.dinus.com/msp/config.yaml

}



function createOrderer() {

  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/ordererOrganizations/dinus.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/dinus.com
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/dinus.com/msp/config.yaml

  infoln "Register orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null


  infoln "Register orderer2"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles  ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register orderer3"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles  ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null


  infoln "Register orderer4"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer4 --id.secret ordererpw --id.type orderer --tls.certfiles  ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register orderer5"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer5 --id.secret ordererpw --id.type orderer --tls.certfiles  ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null




  infoln "Register the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/ordererOrganizations/dinus.com/orderers
  mkdir -p organizations/ordererOrganizations/dinus.com/orderers/dinus.com

  mkdir -p organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com

  infoln "Generate the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/msp --csr.hosts orderer.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/dinus.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/msp/config.yaml

  infoln "Generate the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/tls --enrollment.profile tls --csr.hosts orderer.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/msp/tlscacerts/tlsca.dinus.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/msp/tlscacerts/tlsca.dinus.com-cert.pem

  mkdir -p organizations/ordererOrganizations/dinus.com/users
  mkdir -p organizations/ordererOrganizations/dinus.com/users/Admin@dinus.com


  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com

  infoln "Generate the orderer2 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com/msp --csr.hosts orderer2.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/dinus.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com/msp/config.yaml

  infoln "Generate the orderer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com/tls --enrollment.profile tls --csr.hosts orderer2.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com/msp/tlscacerts/tlsca.dinus.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer2.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/msp/tlscacerts/tlsca.dinus.com-cert.pem



  # -----------------------------------------------------------------------
  #  Orderer 3

  mkdir -p organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com

  infoln "Generate the orderer3 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com/msp --csr.hosts orderer3.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/dinus.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com/msp/config.yaml

  infoln "Generate the orderer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com/tls --enrollment.profile tls --csr.hosts orderer3.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com/msp/tlscacerts/tlsca.dinus.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer3.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/msp/tlscacerts/tlsca.dinus.com-cert.pem




  # -----------------------------------------------------------------------
  #  Orderer 4

  mkdir -p organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com

  infoln "Generate the orderer4 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com/msp --csr.hosts orderer4.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/dinus.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com/msp/config.yaml

  infoln "Generate the orderer4-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com/tls --enrollment.profile tls --csr.hosts orderer4.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com/msp/tlscacerts/tlsca.dinus.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer4.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/msp/tlscacerts/tlsca.dinus.com-cert.pem




  # -----------------------------------------------------------------------
  #  Orderer 5

  mkdir -p organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com

  infoln "Generate the orderer5 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com/msp --csr.hosts orderer5.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/dinus.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com/msp/config.yaml

  infoln "Generate the orderer5-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com/tls --enrollment.profile tls --csr.hosts orderer5.dinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com/msp/tlscacerts/tlsca.dinus.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/dinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/dinus.com/orderers/orderer5.dinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/dinus.com/msp/tlscacerts/tlsca.dinus.com-cert.pem



  infoln "Generate the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/dinus.com/users/Admin@dinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/dinus.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/dinus.com/users/Admin@dinus.com/msp/config.yaml

}
