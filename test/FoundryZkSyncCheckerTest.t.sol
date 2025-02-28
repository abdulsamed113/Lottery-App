// SPDX-License-Identifier: MIT

import {Test} from "forge-std/Test.sol";
import {FoundryZkSyncChecker} from "../src/FoundryZkSyncChecker.sol";
import {DeployFoundryZkSyncChecker} from "../script/DeployFoundryZkSyncChecker.s.sol";

pragma solidity ^0.8.26;

contract FoundryZkSyncCheckerTest is Test {
    FoundryZkSyncChecker public contractInstance;
    DeployFoundryZkSyncChecker public deployer;
    function setUp() public {
        deployer = new DeployFoundryZkSyncChecker();
        contractInstance = deployer.run();

    }

    function testExample() public {
        // Add your test logic here
    }
}