// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {Uint96} from "../src/Uint96.sol";

pragma solidity ^0.8.26;

contract DeployUint96 is Script {
    function run() external returns (Uint96) {
        vm.startBroadcast();
        Uint96 constract = new Uint96();
        console2.log(" contract address", address(constract));
        vm.stopBroadcast();
        return constract;
    }
}