// SPDX-License-Identifier: MIT

import {Test} from "forge-std/Test.sol";
import {Test} from "../src/Test.sol";
import {DeployTest} from "../script/DeployTest.s.sol";

pragma solidity ^0.8.26;

contract TestTest is Test {
    Test public contractInstance;
    DeployTest public deployer;
    function setUp() public {
        deployer = new DeployTest();
        contractInstance = deployer.run();

    }

    function testExample() public {
        // Add your test logic here
    }
}