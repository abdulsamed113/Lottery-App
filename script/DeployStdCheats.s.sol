// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {StdCheats} from "../src/StdCheats.sol";

pragma solidity ^0.8.26;

contract DeployStdCheats is Script {
    function run() external returns (StdCheats) {
        vm.startBroadcast();
        StdCheats constract = new StdCheats();
        console2.log(" contract address", address(constract));
        vm.stopBroadcast();
        return constract;
    }
}