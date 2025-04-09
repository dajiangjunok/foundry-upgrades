// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";

import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;

    BoxV1 public boxV1;
    BoxV2 public boxV2;
    address public OWNER = makeAddr("owner");

    address public proxy;

    function setUp() external {
        upgrader = new UpgradeBox();
        deployer = new DeployBox();

        proxy = deployer.run();
    }

    function testProxyStartsAsBoxV1() public {
        console.log("proxy version: ", BoxV1(proxy).version());

        vm.expectRevert();
        BoxV2(proxy).setNumber(7);
    }

    function testUpgrade() public {
        // Arrange  准备升级所需

        upgrader.upgradeBox(proxy, address(new BoxV2()));
        console.log("proxy version: ", BoxV2(proxy).version());
        uint256 expected = 2;
        assertEq(expected, BoxV2(proxy).version());
        // Act 操作代理升级合约到BoxV2
        BoxV2(proxy).setNumber(7);
        // Assert 断言合约升级成功
        assertEq(7, BoxV2(proxy).getNumber());
    }
}
