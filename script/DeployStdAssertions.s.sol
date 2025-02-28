// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {StdAssertions} from "../src/StdAssertions.sol";

pragma solidity ^0.8.26;

contract DeployStdAssertions is Script {
    function run() external returns (StdAssertions) {
        vm.startBroadcast();
        StdAssertions constract = new StdAssertions();
        console2.log(" contract address", address(constract));
        vm.stopBroadcast();
        return constract;
    }
}