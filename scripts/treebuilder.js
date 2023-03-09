import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";

// (1)
const values = [
  ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0"],
  ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "1"],
  ["0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "2"]
];

// (2)
const tree = StandardMerkleTree.of(values, ["address", "uint256"]);

// (3)
console.log('Merkle Root:', tree.root);

// (4)
fs.writeFileSync("tree.json", JSON.stringify(tree.dump()));