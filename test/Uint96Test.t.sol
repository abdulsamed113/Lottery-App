// SPDX-License-Identifier: MIT

import {Test} from "forge-std/Test.sol";
import {Uint96} from "../src/Uint96.sol";
import {DeployUint96} from "../script/DeployUint96.s.sol";

pragma solidity ^0.8.26;

contract Uint96Test is Test {
    Uint96 public contractInstance;
    DeployUint96 public deployer;
    function setUp() public {
        deployer = new DeployUint96();
        contractInstance = deployer.run();

    }

    function testExample() public {
        // Add your test logic here
    }
}