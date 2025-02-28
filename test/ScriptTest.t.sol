// SPDX-License-Identifier: MIT

import {Test} from "forge-std/Test.sol";
import {Script} from "../src/Script.sol";
import {DeployScript} from "../script/DeployScript.s.sol";

pragma solidity ^0.8.26;

contract ScriptTest is Test {
    Script public contractInstance;
    DeployScript public deployer;
    function setUp() public {
        deployer = new DeployScript();
        contractInstance = deployer.run();

    }

    function testExample() public {
        // Add your test logic here
    }
}