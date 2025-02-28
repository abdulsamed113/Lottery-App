// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {FoundryZkSyncChecker} from "../src/FoundryZkSyncChecker.sol";

pragma solidity ^0.8.26;

contract DeployFoundryZkSyncChecker is Script {
    function run() external returns (FoundryZkSyncChecker) {
        vm.startBroadcast();
        FoundryZkSyncChecker constract = new FoundryZkSyncChecker();
        console2.log(" contract address", address(constract));
        vm.stopBroadcast();
        return constract;
    }
}