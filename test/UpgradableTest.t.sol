// SPDX-License-Identifier: MIT

import {Test} from "forge-std/Test.sol";
import {Upgradable} from "../src/Upgradable.sol";
import {DeployUpgradable} from "../script/DeployUpgradable.s.sol";

pragma solidity ^0.8.26;

contract UpgradableTest is Test {
    Upgradable public contractInstance;
    DeployUpgradable public deployer;
    function setUp() public {
        deployer = new DeployUpgradable();
        contractInstance = deployer.run();

    }

    function testExample() public {
        // Add your test logic here
    }
}