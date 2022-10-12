const { buildCCPPetani ,buildCCPPengepul,buildCCPDistributor,buildCCPRetailer} = require("./AppUtils");

exports.getCCP = (org) => {
    let ccp;
    switch (org) {
        case 1:
            ccp = buildCCPPetani();
            break;
        case 2:
            ccp = buildCCPPengepul();
            break;
        case 3:
            ccp = buildCCPDistributor();
            break;
        case 4:
            ccp = buildCCPRetailer();
            break;
    }
    return ccp;
}