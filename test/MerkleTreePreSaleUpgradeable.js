const { expect } = require('chai');
const { ethers } = require('hardhat');

let merkleTreeProxy;

describe('UpgradeTest', function () {
    const merkleRoot = '0x0c0c38c555dd95bd6e34b91e35d4d04b05e09137825a5c25c5147b7c64b3e718';
    const ownerAccounts = [
        '0x503f38a9c967ed597e47fe25643985f032b072db8075426a92110f82df48dfcb',
        '0x7e5bfb82febc4c2c8529167104271ceec190eafdca277314912eaabdb67c6e5f',
        '0xcc6d63f85de8fef05446ebdd3c537c72152d0fc437fd7aa62b3019b79bd1fdd4'
    ];

    beforeEach(async function () {

        let v0Factory = await ethers.getContractFactory("MerkleTreePreSaleUpgradeableV0");
        merkleTreeProxy = await upgrades.deployProxy(v0Factory, [merkleRoot]);

        let v1Factory = await ethers.getContractFactory("MerkleTreePreSaleUpgradeableV1");
        merkleTreeProxy = await upgrades.upgradeProxy(merkleTreeProxy.address, v1Factory, [merkleRoot]);
        //sanctionsV0 = await SanctionsFactory.deploy();
        //await sanctionsV0.deployed();
    });

    it('gets the name correct', async function () {
         let name = await merkleTreeProxy.name();
         expect(name).to.equal("MerklePresaleNFT");
     });
    
    it('can force transfer tokens', async function () {
        const [owner, addr1, addr2] = await ethers.getSigners();
        
        await merkleTreeProxy.connect(addr1).mint({value: ethers.utils.parseEther('0.001')});
        await merkleTreeProxy.connect(owner).forceTransfer(addr1.address, addr2.address, 0);
        expect(await merkleTreeProxy.ownerOf(0)).to.equal(addr2.address.toString());
    });
});