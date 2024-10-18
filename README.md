## Uniswap V3 Deployment

## Primary Contracts:

- [`UniswapV3Factory.sol`](lib/v3-core/contracts/UniswapV3Factory.sol)
- [`UniswapV3Pool.sol`](lib/v3-core/contracts/UniswapV3Pool.sol)
- [`NonfungiblePositionManager.sol`](lib/v3-periphery/contracts/NonfungiblePositionManager.sol)
- [`SwapRouter.sol`](lib/v3-periphery/contracts/SwapRouter.sol)

## Deployment Steps:

1. [Deploy 2 ERC20 tokens (e.g. _TOKENA_ and _TOKENB_)](script/UniswapV3Deploy.s.sol#L27)
2. [Deploy WETH to pass into the UniswapV3Factory constructor](script/UniswapV3Deploy.s.sol#L30)
3. [Deploy UniswapV3Factory with the WETH address](script/UniswapV3Deploy.s.sol#L33)
4. [Create A Poolwith Token A and Token B](script/UniswapV3Deploy.s.sol#L36)
5. [Get the token0 and token1 addresses](script/UniswapV3Deploy.s.sol#L39)
6. [Deploy the Uniswap Swap Router from the Periphery](script/UniswapV3Deploy.s.sol#L42)
7. [Deploy the position manager from the Periphery](script/UniswapV3Deploy.s.sol#L47)
8. [Approve the position manager to spend the tokenA and tokenB to provide initial liquidity](script/UniswapV3Deploy.s.sol#L50)
9. [Initialize the pool](script/UniswapV3Deploy.s.sol#L59)
10. [Provide liquidity and mint a position](script/UniswapV3Deploy.s.sol#L77)
11. [Approve for the swap router to spend the tokenA and for a swap from tokenA to tokenB](script/UniswapV3Deploy.s.sol#L80)
12. [Execute the swap](script/UniswapV3Deploy.s.sol#L92)

## Deployment Script:

Set up foundry and compile contracts:

```bash
forge install
forge build
```

To spin up a local environment, run the following commands:

```bash
anvil
```

To execute the deployment script on the local network, run the following command:

```bash
forge script script/UniswapV3Deploy.s.sol:UniV3DeployScript --rpc-url 127.0.0.1:8545 --broadcast --private-key <PRIVATE_KEY> -vv
```

To deploy this script to Arbitrum Seploia, run the following command:

```bash
forge script script/UniswapV3Deploy.s.sol:UniV3DeployScript --rpc-url <RPC_URL> --broadcast --private-key <PRIVATE_KEY> -vv
```
