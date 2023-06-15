const { Contract } = require("ethers");

(async () => {
    try {
        const [owner, addr1, addr2] = await ethers.getSigners();

        const v0Factory = await ethers.getContractFactory("MerkleTreePreSaleUpgradeableV0");
        const v0Contract = await v0Factory.attach('0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0', );

        v0Contract.mint();
  
      console.log(
        v0Contract
      );

    } catch (err) {
      console.error(err);
      process.exitCode = 1;
    }
  })();