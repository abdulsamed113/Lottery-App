// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {ZkSyncChainChecker} from "../src/ZkSyncChainChecker.sol";

pragma solidity ^0.8.26;

contract DeployZkSyncChainChecker is Script {
    function run() external returns (ZkSyncChainChecker) {
        vm.startBroadcast();
        ZkSyncChainChecker constract = new ZkSyncChainChecker();
        console2.log(" contract address", address(constract));
        vm.stopBroadcast();
        return constract;
    }
}