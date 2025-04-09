// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

// @dev 升级Box合约的脚本
contract UpgradeBox is Script {
    // @dev 运行升级脚本
    function run() external returns (address) {
        // @dev 获取最近部署的ERC1967代理合约地址
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "ERC1967Proxy",
            block.chainid
        );

        vm.startBroadcast();
        BoxV2 boxV2 = new BoxV2();
        vm.stopBroadcast();

        address proxy = upgradeBox(mostRecentlyDeployed, address(boxV2));
        return proxy;
    }

    function upgradeBox(
        address proxyAddress,
        address newBox
    ) public returns (address) {
        vm.startBroadcast();
        BoxV1 proxy = BoxV1(proxyAddress);
        proxy.upgradeToAndCall(newBox, ""); // 升级合约, 代理合同指向这个新地址
        vm.stopBroadcast();
        return address(proxy);
    }
}
