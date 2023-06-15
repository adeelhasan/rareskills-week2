(async () => {
    try {
        //localhost const proxyAddress = '0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0';
        const proxyAddress = '0xedad50a113C6bCE96c99587FDf2F8CcAa6216Ec9'; //goerli

        const v2Factory = await ethers.getContractFactory("MerkleTreePreSaleUpgradeableV2");
        const upgradedInstance = await upgrades.upgradeProxy(proxyAddress, v2Factory);
    
      console.log(
        `Deployed upgraded proxy at ${upgradedInstance.address}, should be the same address as before`
      );

    } catch (err) {
      console.error(err);
      process.exitCode = 1;
    }
  })();