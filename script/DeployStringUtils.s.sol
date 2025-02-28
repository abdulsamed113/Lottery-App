// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {StringUtils} from "../src/StringUtils.sol";

pragma solidity ^0.8.26;

contract DeployStringUtils is Script {
    function run() external returns (StringUtils) {
        vm.startBroadcast();
        StringUtils constract = new StringUtils();
        console2.log(" contract address", address(constract));
        vm.stopBroadcast();
        return constract;
    }
}