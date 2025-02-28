// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {Test.t} from "../src/Test.t.sol";

pragma solidity ^0.8.26;

contract DeployTest.t is Script {
    function run() external returns (Test.t) {
        vm.startBroadcast();
        Test.t constract = new Test.t();
        console2.log(" contract address", address(constract));
        vm.stopBroadcast();
        return constract;
    }
}