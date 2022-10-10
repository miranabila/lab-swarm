const { buildCCPOrg1 ,buildCCPOrg2,buildCCPOrg3,buildCCPOrg4} = require("./AppUtils");

exports.getCCP = (org) => {
    let ccp;
    switch (org) {
        case 1:
            ccp = buildCCPOrg1();
            break;
        case 2:
            ccp = buildCCPOrg2();
            break;
        case 3:
            ccp = buildCCPOrg3();
            break;
        case 4:
            ccp = buildCCPOrg4();
            break;
    }
    return ccp;
}