(async () => {
    try {
        const merkleRoot = '0x0c0c38c555dd95bd6e34b91e35d4d04b05e09137825a5c25c5147b7c64b3e718';

        const v0Factory = await ethers.getContractFactory("MerkleTreePreSaleUpgradeableV0");
        const merkleTreeProxy = await upgrades.deployProxy(v0Factory, [merkleRoot]);
  
      await merkleTreeProxy.deployed();
  
      console.log(
        `Deployed contract at ${merkleTreeProxy.address}`
      );

    } catch (err) {
      console.error(err);
      process.exitCode = 1;
    }
  })();