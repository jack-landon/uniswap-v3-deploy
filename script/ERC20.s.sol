// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
// import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {MockERC20} from "../src/mocks/MockERC20.sol";

contract ERC20DeployScript is Script {
    function run() public {
        vm.startBroadcast();

        // address deployer = 0x3d446fb6Bff1fcC04A9ea78FebcdB5e316d7BD69;

        MockERC20 tokenA = new MockERC20("Token A", "TOKENA");
        MockERC20 tokenB = new MockERC20("Token B", "TOKENB");

        console.log("Token A Address: ", address(tokenA));
        console.log("Token B Address: ", address(tokenB));
        console.log("Balance of TokenA", tokenA.balanceOf(msg.sender));

        vm.stopBroadcast();
    }
}
