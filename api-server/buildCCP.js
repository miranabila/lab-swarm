const { buildCCPCoe1 ,buildCCPCoe2,buildCCPCoe3,buildCCPCoe4} = require("./AppUtils");

exports.getCCP = (org) => {
    let ccp;
    switch (org) {
        case 1:
            ccp = buildCCPCoe1();
            break;
        case 2:
            ccp = buildCCPCoe2();
            break;
        case 3:
            ccp = buildCCPCoe3();
            break;
        case 4:
            ccp = buildCCPCoe4();
            break;
    }
    return ccp;
}