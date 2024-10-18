// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;
pragma abicoder v2;

import {Script, console} from "forge-std/Script.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {UniswapV3Factory} from "lib/v3-core/contracts/UniswapV3Factory.sol";
import {SwapRouter, ISwapRouter} from "lib/v3-periphery/contracts/SwapRouter.sol";
import {IERC20} from "../src/interfaces/IERC20.sol";
import {WETH} from "../src/mocks/MockWETH.sol";
import {IUniswapV3Pool} from "lib/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {NonfungiblePositionManager, INonfungiblePositionManager} from "lib/v3-periphery/contracts/NonfungiblePositionManager.sol";
import {MockERC20} from "../src/mocks/MockERC20.sol";

contract UniV3DeployScript is Script {
    MockERC20 tokenA;
    MockERC20 tokenB;
    WETH weth;
    UniswapV3Factory factory;
    IUniswapV3Pool pool;
    address token0;
    address token1;

    function run() public {
        vm.startBroadcast();

        // Deploy the tokens
        tokenA = new MockERC20("Token A", "TOKENA");
        tokenB = new MockERC20("Token B", "TOKENB");
        weth = new WETH();

        // Deploy Uniswap Factory
        factory = new UniswapV3Factory();

        // Create Uniswap Pool
        pool = IUniswapV3Pool(factory.createPool(address(tokenA), address(tokenB), 3000));

        // Get the token0 and token1 addresses
        token0 = pool.token0();
        token1 = pool.token1();

        // Deploy the Uni router
        SwapRouter swapRouter = new SwapRouter(address(factory), address(weth));

        // Deploy the Position Manager
        address tokenDescriptor = address(0);
        NonfungiblePositionManager positionManager = new NonfungiblePositionManager(address(factory), address(weth), tokenDescriptor);

        // Approve the position manager to spend the tokens
        IERC20(token0).approve(address(positionManager), type(uint256).max);
        IERC20(token1).approve(address(positionManager), type(uint256).max);

        // Add Liquidity to the pool
        int24 MIN_TICK = -887272;
        int24 MAX_TICK = -MIN_TICK;
        int24 TICK_SPACING = 60;

        // Initialize the pool
        pool.initialize(uint160(1 << 96));

        // Prepare Liquidity Position
        INonfungiblePositionManager.MintParams memory positionParams = INonfungiblePositionManager.MintParams({
            token0: token0,
            token1: token1,
            fee: 3000,
            tickLower: int24((MIN_TICK / TICK_SPACING) * TICK_SPACING),
            tickUpper: int24((MAX_TICK / TICK_SPACING) * TICK_SPACING),
            amount0Desired: 10e18,
            amount1Desired: 10e18,
            amount0Min: 1,
            amount1Min: 1,
            recipient: msg.sender,
            deadline: block.timestamp + 20
        });

        // Add Liquidity
        (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1) = positionManager.mint(positionParams);

        // Approve the router to spend the tokens for the swap
        IERC20(token0).approve(address(swapRouter), 1000e18);

        // Prepare the Swap Params
        ISwapRouter.ExactInputParams memory swapParams = ISwapRouter.ExactInputParams({
            path: abi.encodePacked(IERC20(token0), uint24(1000), IERC20(token1)),
            recipient: msg.sender,
            deadline: block.timestamp + 20,
            amountIn: 1000,
            amountOutMinimum: 0
        });

        // Execute the swap
        uint256 amountOut = swapRouter.exactInput(swapParams);

        console.log("Amount of token 1 tokens received: ", amountOut);

        vm.stopBroadcast();
    }
}