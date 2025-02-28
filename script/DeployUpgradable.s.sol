// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {Upgradable} from "../src/Upgradable.sol";

pragma solidity ^0.8.26;

contract DeployUpgradable is Script {
    function run() external returns (Upgradable) {
        vm.startBroadcast();
        Upgradable constract = new Upgradable();
        console2.log(" contract address", address(constract));
        vm.stopBroadcast();
        return constract;
    }
}