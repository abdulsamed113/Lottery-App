// SPDX-License-Identifier: MIT

import {Test} from "forge-std/Test.sol";
import {ZkSyncChainChecker} from "../src/ZkSyncChainChecker.sol";
import {DeployZkSyncChainChecker} from "../script/DeployZkSyncChainChecker.s.sol";

pragma solidity ^0.8.26;

contract ZkSyncChainCheckerTest is Test {
    ZkSyncChainChecker public contractInstance;
    DeployZkSyncChainChecker public deployer;
    function setUp() public {
        deployer = new DeployZkSyncChainChecker();
        contractInstance = deployer.run();

    }

    function testExample() public {
        // Add your test logic here
    }
}