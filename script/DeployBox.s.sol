// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

// @dev 部署Box合约的脚本
contract DeployBox is Script {
    // @dev 运行部署脚本
    // @return proxy代理合约地址
    function run() external returns (address) {
        address proxy = deployBox();
        return proxy;
    }

    // @dev 部署Box合约和代理合约
    // @return 返回代理合约地址
    function deployBox() internal returns (address) {
        vm.startBroadcast();
        // 部署BoxV1实现合约
        BoxV1 boxV1 = new BoxV1();
        // 部署代理合约,指向BoxV1,初始化数据为空
        ERC1967Proxy proxy = new ERC1967Proxy(address(boxV1), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}
