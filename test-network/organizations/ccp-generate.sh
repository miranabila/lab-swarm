#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}


function PetaniCCP {
    ORG=1
    P0PORT=7051
    CAPORT=7054
    PEERPEM=organizations/peerOrganizations/petani.coedinus.com/tlsca/tlsca.petani.coedinus.com-cert.pem
    CAPEM=organizations/peerOrganizations/petani.coedinus.com/ca/ca.petani.coedinus.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/petani.coedinus.com/connection-petani.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/petani.coedinus.com/connection-petani.yaml

}

function PengepulCCP {
    ORG=2
    P0PORT=9051
    CAPORT=8054
    PEERPEM=organizations/peerOrganizations/pengepul.coedinus.com/tlsca/tlsca.pengepul.coedinus.com-cert.pem
    CAPEM=organizations/peerOrganizations/pengepul.coedinus.com/ca/ca.pengepul.coedinus.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/pengepul.coedinus.com/connection-pengepul.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/pengepul.coedinus.com/connection-pengepul.yaml

}

function DistributorCCP {

    ORG=3
    P0PORT=11051
    CAPORT=9054
    PEERPEM=organizations/peerOrganizations/distributor.coedinus.com/tlsca/tlsca.distributor.coedinus.com-cert.pem
    CAPEM=organizations/peerOrganizations/distributor.coedinus.com/ca/ca.distributor.coedinus.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/distributor.coedinus.com/connection-distributor.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/distributor.coedinus.com/connection-distributor.yaml

}

function RetailerCCP {

    ORG=4
    P0PORT=13051
    CAPORT=11054
    PEERPEM=organizations/peerOrganizations/retailer.coedinus.com/tlsca/tlsca.retailer.coedinus.com-cert.pem
    CAPEM=organizations/peerOrganizations/retailer.coedinus.com/ca/ca.retailer.coedinus.com-cert.pem

    echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/retailer.coedinus.com/connection-retailer.json
    echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/retailer.coedinus.com/connection-retailer.yaml

}
