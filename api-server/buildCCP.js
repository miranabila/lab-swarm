const { buildCCPpetani ,buildCCPpengepul,buildCCPdistributor,buildCCPretailer} = require("./AppUtils");

exports.getCCP = (org) => {
    let ccp;
    switch (org) {
        case 1:
            ccp = buildCCPpetani();
            break;
        case 2:
            ccp = buildCCPpengepul();
            break;
        case 3:
            ccp = buildCCPdistributor();
            break;
        case 4:
            ccp = buildCCPretailer();
            break;
    }
    return ccp;
}