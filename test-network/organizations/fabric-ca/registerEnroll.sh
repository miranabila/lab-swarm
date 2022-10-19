#!/bin/bash

source scriptUtils.sh
export PATH=${PWD}/../bin:$PATH
function createPetani() {
  mkdir channel-artifacts
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/petani.coedinus.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/petani.coedinus.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-petani --tls.certfiles ${PWD}/organizations/fabric-ca/petani/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-petani.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-petani.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-petani.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-petani.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/petani.coedinus.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-petani --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/petani/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-petani --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/petani/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-petani --id.name petaniadmin --id.secret petaniadminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/petani/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/petani.coedinus.com/peers
  mkdir -p organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-petani -M ${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/msp --csr.hosts peer0.petani.coedinus.com --tls.certfiles ${PWD}/organizations/fabric-ca/petani/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/petani.coedinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-petani -M ${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/tls --enrollment.profile tls --csr.hosts peer0.petani.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/petani/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/opetani.coedinus.com/peers/peer0.petani.coedinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/petani.coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/petani.coedinus.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/petani.coedinus.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/petani.coedinus.com/tlsca/tlsca.petani.coedinus.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/petani.coedinus.com/ca
  cp ${PWD}/organizations/peerOrganizations/petani.coedinus.com/peers/peer0.petani.coedinus.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/petani.coedinus.com/ca/ca.petani.coedinus.com-cert.pem

  mkdir -p organizations/peerOrganizations/petani.coedinus.com/users
  mkdir -p organizations/peerOrganizations/petani.coedinus.com/users/User1@petani.coedinus.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-petani -M ${PWD}/organizations/peerOrganizations/petani.coedinus.com/users/User1@petani.coedinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/petani/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/petani.coedinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/petani.coedinus.com/users/User1@petani.coedinus.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/petani.coedinus.com/users/Admin@petani.coedinus.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://petaniadmin:petaniadminpw@localhost:7054 --caname ca-petani -M ${PWD}/organizations/peerOrganizations/petani.coedinus.com/users/Admin@petani.coedinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/petani/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/petani.coedinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/petani.coedinus.com/users/Admin@petani.coedinus.com/msp/config.yaml

}

function createPengepul() {
  mkdir channel-artifacts
  mkdir -p organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/msp/tlscacerts/
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/pengepul.coedinus.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-pengepul --tls.certfiles ${PWD}/organizations/fabric-ca/pengepul/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-pengepul.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-pengepul.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-pengepul.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-pengepul.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-pengepul --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/pengepul/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-pengepul --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/pengepul/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-pengepul --id.name pengepuladmin --id.secret pengepuladminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/pengepul/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/pengepul.coedinus.com/peers
  mkdir -p organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-pengepul -M ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/msp --csr.hosts peer0.pengepul.coedinus.com --tls.certfiles ${PWD}/organizations/fabric-ca/pengepul/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-pengepul -M ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/tls --enrollment.profile tls --csr.hosts peer0.pengepul.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/pengepul/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/tlsca/tlsca.pengepul.coedinus.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/ca
  cp ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/peers/peer0.pengepul.coedinus.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/ca/ca.pengepul.coedinus.com-cert.pem

  mkdir -p organizations/peerOrganizations/pengepul.coedinus.com/users
  mkdir -p organizations/peerOrganizations/pengepul.coedinus.com/users/User1@pengepul.coedinus.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-pengepul -M ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/users/User1@pengepul.coedinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/pengepul/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/users/User1@pengepul.coedinus.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/pengepul.coedinus.com/users/Admin@pengepul.coedinus.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://pengepuladmin:pengepuladminpw@localhost:8054 --caname ca-pengepul -M ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/users/Admin@pengepul.coedinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/pengepul/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/pengepul.coedinus.com/users/Admin@pengepul.coedinus.com/msp/config.yaml

}



function createDistributor() {
  mkdir channel-artifacts
  mkdir -p organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/msp/tlscacerts/
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/distributor.coedinus.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/distributor.coedinus.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-distributor --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-distributor.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-distributor.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-distributor.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-distributor.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/distributor.coedinus.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-distributor --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-distributor --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-distributor --id.name distributoradmin --id.secret distributoradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/distributor.coedinus.com/peers
  mkdir -p organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-distributor -M ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/msp --csr.hosts peer0.distributor.coedinus.com --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-distributor -M ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/tls --enrollment.profile tls --csr.hosts peer0.distributor.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/tlsca/tlsca.distributor.coedinus.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/ca
  cp ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/peers/peer0.distributor.coedinus.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/ca/ca.distributor.coedinus.com-cert.pem

  mkdir -p organizations/peerOrganizations/distributor.coedinus.com/users
  mkdir -p organizations/peerOrganizations/distributor.coedinus.com/users/User1@distributor.coedinus.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca-distributor -M ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/users/User1@distributor.coedinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/users/User1@distributor.coedinus.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/distributor.coedinus.com/users/Admin@distributor.coedinus.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://distributoradmin:distributoradminpw@localhost:9054 --caname ca-distributor -M ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/users/Admin@distributor.coedinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/distributor/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/distributor.coedinus.com/users/Admin@distributor.coedinus.com/msp/config.yaml

}


function createRetailer() {
  mkdir channel-artifacts
  mkdir -p organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/msp/tlscacerts/
  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/peerOrganizations/retailer.coedinus.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/retailer.coedinus.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-retailer --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-retailer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-retailer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-retailer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-retailer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/retailer.coedinus.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-retailer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-retailer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-retailer --id.name retaileradmin --id.secret retaileradminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/retailer.coedinus.com/peers
  mkdir -p organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-retailer -M ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/msp --csr.hosts peer0.retailer.coedinus.com --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-retailer -M ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/tls --enrollment.profile tls --csr.hosts peer0.retailer.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/tlsca/tlsca.retailer.coedinus.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/ca
  cp ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/peers/peer0.retailer.coedinus.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/ca/ca.retailer.coedinus.com-cert.pem

  mkdir -p organizations/peerOrganizations/retailer.coedinus.com/users
  mkdir -p organizations/peerOrganizations/retailer.coedinus.com/users/User1@retailer.coedinus.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-retailer -M ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/users/User1@retailer.coedinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/users/User1@retailer.coedinus.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/retailer.coedinus.com/users/Admin@retailer.coedinus.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://retaileradmin:retaileradminpw@localhost:11054 --caname ca-retailer -M ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/users/Admin@retailer.coedinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/retailer/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/retailer.coedinus.com/users/Admin@retailer.coedinus.com/msp/config.yaml

}



function createOrderer() {

  infoln "Enroll the CA admin"
  sleep 2
  mkdir -p organizations/ordererOrganizations/coedinus.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/coedinus.com
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
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/coedinus.com/msp/config.yaml

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

  mkdir -p organizations/ordererOrganizations/coedinus.com/orderers
  mkdir -p organizations/ordererOrganizations/coedinus.com/orderers/coedinus.com

  mkdir -p organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com

  infoln "Generate the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/msp --csr.hosts orderer.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/msp/config.yaml

  infoln "Generate the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/tls --enrollment.profile tls --csr.hosts orderer.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/msp/tlscacerts/tlsca.coedinus.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/tlscacerts/tlsca.coedinus.com-cert.pem

  mkdir -p organizations/ordererOrganizations/coedinus.com/users
  mkdir -p organizations/ordererOrganizations/coedinus.com/users/Admin@coedinus.com


  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com

  infoln "Generate the orderer2 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com/msp --csr.hosts orderer2.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com/msp/config.yaml

  infoln "Generate the orderer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com/tls --enrollment.profile tls --csr.hosts orderer2.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com/msp/tlscacerts/tlsca.coedinus.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer2.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/tlscacerts/tlsca.coedinus.com-cert.pem



  # -----------------------------------------------------------------------
  #  Orderer 3

  mkdir -p organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com

  infoln "Generate the orderer3 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com/msp --csr.hosts orderer3.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com/msp/config.yaml

  infoln "Generate the orderer3-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com/tls --enrollment.profile tls --csr.hosts orderer3.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com/msp/tlscacerts/tlsca.coedinus.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer3.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/tlscacerts/tlsca.coedinus.com-cert.pem




  # -----------------------------------------------------------------------
  #  Orderer 4

  mkdir -p organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com

  infoln "Generate the orderer4 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com/msp --csr.hosts orderer4.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com/msp/config.yaml

  infoln "Generate the orderer4-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com/tls --enrollment.profile tls --csr.hosts orderer4.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com/msp/tlscacerts/tlsca.coedinus.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer4.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/tlscacerts/tlsca.coedinus.com-cert.pem




  # -----------------------------------------------------------------------
  #  Orderer 5

  mkdir -p organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com

  infoln "Generate the orderer5 msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com/msp --csr.hosts orderer5.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com/msp/config.yaml

  infoln "Generate the orderer5-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com/tls --enrollment.profile tls --csr.hosts orderer5.coedinus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com/msp/tlscacerts/tlsca.coedinus.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/orderers/orderer5.coedinus.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/tlscacerts/tlsca.coedinus.com-cert.pem



  infoln "Generate the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:10054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/coedinus.com/users/Admin@coedinus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/coedinus.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/coedinus.com/users/Admin@coedinus.com/msp/config.yaml

}
