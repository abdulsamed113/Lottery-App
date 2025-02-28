// SPDX-License-Identifier: MIT

import {Test} from "forge-std/Test.sol";
import {Test.t} from "../src/Test.t.sol";
import {DeployTest.t} from "../script/DeployTest.t.s.sol";

pragma solidity ^0.8.26;

contract Test.tTest is Test {
    Test.t public contractInstance;
    DeployTest.t public deployer;
    function setUp() public {
        deployer = new DeployTest.t();
        contractInstance = deployer.run();

    }

    function testExample() public {
        // Add your test logic here
    }
}