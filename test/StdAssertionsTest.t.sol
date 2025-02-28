// SPDX-License-Identifier: MIT

import {Test} from "forge-std/Test.sol";
import {StdAssertions} from "../src/StdAssertions.sol";
import {DeployStdAssertions} from "../script/DeployStdAssertions.s.sol";

pragma solidity ^0.8.26;

contract StdAssertionsTest is Test {
    StdAssertions public contractInstance;
    DeployStdAssertions public deployer;
    function setUp() public {
        deployer = new DeployStdAssertions();
        contractInstance = deployer.run();

    }

    function testExample() public {
        // Add your test logic here
    }
}