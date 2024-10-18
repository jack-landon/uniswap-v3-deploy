// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

import {Script, console} from "forge-std/Script.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {IUniswapV3Factory} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import {}
import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {MockERC20} from "../src/mocks/MockERC20.sol";

contract UniV3DeployScript is Script {
    function run() public {
        vm.startBroadcast();

        IERC20 tokenA = IERC20(0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6);
        IERC20 tokenB = IERC20(0x8A791620dd6260079BF849Dc5567aDC3F2FdC318);

        vm.stopBroadcast();
    }
}
