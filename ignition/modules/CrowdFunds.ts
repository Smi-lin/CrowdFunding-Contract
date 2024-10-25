import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const CrowdFundsModule = buildModule("CrowdFundsModule", (c) => {
  const crowdFunds = c.contract("CrowdFunding");

  return { crowdFunds };
});

export default CrowdFundsModule;

// CrowdFundsModule#CrowdFunding - 0x55aA4A1622B23f86D666DBbC53Eee6e3BcF60D4E

//  https://sepolia.basescan.org/address/0x648DCf4C6b8bCf722E72645272804f39e7863bb9#code