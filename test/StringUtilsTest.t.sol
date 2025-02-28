// SPDX-License-Identifier: MIT

import {Test} from "forge-std/Test.sol";
import {StringUtils} from "../src/StringUtils.sol";
import {DeployStringUtils} from "../script/DeployStringUtils.s.sol";

pragma solidity ^0.8.26;

contract StringUtilsTest is Test {
    StringUtils public contractInstance;
    DeployStringUtils public deployer;
    function setUp() public {
        deployer = new DeployStringUtils();
        contractInstance = deployer.run();

    }

    function testExample() public {
        // Add your test logic here
    }
}