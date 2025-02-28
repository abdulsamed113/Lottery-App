// SPDX-License-Identifier: MIT

import {Test} from "forge-std/Test.sol";
import {StdChains} from "../src/StdChains.sol";
import {DeployStdChains} from "../script/DeployStdChains.s.sol";

pragma solidity ^0.8.26;

contract StdChainsTest is Test {
    StdChains public contractInstance;
    DeployStdChains public deployer;
    function setUp() public {
        deployer = new DeployStdChains();
        contractInstance = deployer.run();

    }

    function testExample() public {
        // Add your test logic here
    }
}