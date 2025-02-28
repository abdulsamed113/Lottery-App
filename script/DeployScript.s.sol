// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {Script} from "../src/Script.sol";

pragma solidity ^0.8.26;

contract DeployScript is Script {
    function run() external returns (Script) {
        vm.startBroadcast();
        Script constract = new Script();
        console2.log(" contract address", address(constract));
        vm.stopBroadcast();
        return constract;
    }
}