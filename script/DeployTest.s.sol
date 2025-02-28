// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {Test} from "../src/Test.sol";

pragma solidity ^0.8.26;

contract DeployTest is Script {
    function run() external returns (Test) {
        vm.startBroadcast();
        Test constract = new Test();
        console2.log(" contract address", address(constract));
        vm.stopBroadcast();
        return constract;
    }
}