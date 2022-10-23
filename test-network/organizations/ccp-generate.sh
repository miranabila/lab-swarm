#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${MSP}/$2/" \
        -e "s/\${P0PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${MSP}/$2/" \
        -e "s/\${P0PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}


function Coe1CCP {
    ORG=1
    MSP=Petani
    P0PORT=7051
    CAPORT=7054
    PEERPEM=organizations/peerOrganizations/coe1.dinus.com/tlsca/tlsca.coe1.dinus.com-cert.pem
    CAPEM=organizations/peerOrganizations/coe1.dinus.com/ca/ca.coe1.dinus.com-cert.pem

    echo "$(json_ccp $ORG $MSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/coe1.dinus.com/connection-coe1.json
    echo "$(yaml_ccp $ORG $MSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/coe1.dinus.com/connection-coe1.yaml

}

function Coe2CCP {
    ORG=2
    MSP=Pengepul
    P0PORT=9051
    CAPORT=8054
    PEERPEM=organizations/peerOrganizations/coe2.dinus.com/tlsca/tlsca.coe2.dinus.com-cert.pem
    CAPEM=organizations/peerOrganizations/coe2.dinus.com/ca/ca.coe2.dinus.com-cert.pem

    echo "$(json_ccp $ORG $MSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/coe2.dinus.com/connection-coe2.json
    echo "$(yaml_ccp $ORG $MSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/coe2.dinus.com/connection-coe2.yaml

}

function Coe3CCP {
    ORG=3
    MSP=Distributor
    P0PORT=11051
    CAPORT=9054
    PEERPEM=organizations/peerOrganizations/coe3.dinus.com/tlsca/tlsca.coe3.dinus.com-cert.pem
    CAPEM=organizations/peerOrganizations/coe3.dinus.com/ca/ca.coe3.dinus.com-cert.pem

    echo "$(json_ccp $ORG $MSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/coe3.dinus.com/connection-coe3.json
    echo "$(yaml_ccp $ORG $MSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/coe3.dinus.com/connection-coe3.yaml

}

function Coe4CCP {
    ORG=4
    MSP=Retailer
    P0PORT=13051
    CAPORT=11054
    PEERPEM=organizations/peerOrganizations/coe4.dinus.com/tlsca/tlsca.coe4.dinus.com-cert.pem
    CAPEM=organizations/peerOrganizations/coe4.dinus.com/ca/ca.coe4.dinus.com-cert.pem

    echo "$(json_ccp $ORG $MSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/coe4.dinus.com/connection-coe4.json
    echo "$(yaml_ccp $ORG $MSP $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/coe4.dinus.com/connection-coe4.yaml

}
