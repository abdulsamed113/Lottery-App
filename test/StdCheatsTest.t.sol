// SPDX-License-Identifier: MIT

import {Test} from "forge-std/Test.sol";
import {StdCheats} from "../src/StdCheats.sol";
import {DeployStdCheats} from "../script/DeployStdCheats.s.sol";

pragma solidity ^0.8.26;

contract StdCheatsTest is Test {
    StdCheats public contractInstance;
    DeployStdCheats public deployer;
    function setUp() public {
        deployer = new DeployStdCheats();
        contractInstance = deployer.run();

    }

    function testExample() public {
        // Add your test logic here
    }
}