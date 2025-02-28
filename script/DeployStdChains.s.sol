// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {StdChains} from "../src/StdChains.sol";

pragma solidity ^0.8.26;

contract DeployStdChains is Script {
    function run() external returns (StdChains) {
        vm.startBroadcast();
        StdChains constract = new StdChains();
        console2.log(" contract address", address(constract));
        vm.stopBroadcast();
        return constract;
    }
}