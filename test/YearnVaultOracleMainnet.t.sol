// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import "../src/YearnVaultOracle.sol";

contract YearnVaultOracleMainnetTest is Test {
    YearnVaultOracle public yearnVaultOracle;
    uint256 mainnetFork;

    address BTC_FEED_ADDRESS = address(0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c);
    address ETH_FEED_ADDRESS = address(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    address USDT_FEED_ADDRESS = address(0x3E7d1eAB13ad0104d2750B8863b489D65364e32D);
    address TRI_CRYPTO_ADDRESS = address(0xD51a44d3FaE010294C616388b506AcdA1bfAAE46);
    address YEARN_VAULT_ADDRESS = address(0x8078198Fc424986ae89Ce4a910Fc109587b6aBF3);
    address RANDOM_USER = address(0x3009b437be854b834b253Ca098D2ffdeF0EB1e28);
    address TRI_CRYPTO_TOKEN_ADDRESS = address(0xc4AD29ba4B3c580e6D59105FFf484999997675Ff);

    function setUp() public {
        vm.selectFork(vm.createFork(vm.rpcUrl("mainnet")));
        yearnVaultOracle =
        new YearnVaultOracle(ETH_FEED_ADDRESS, BTC_FEED_ADDRESS, USDT_FEED_ADDRESS, TRI_CRYPTO_ADDRESS, YEARN_VAULT_ADDRESS);
    }

    function testPrice() public {
        uint256 price = yearnVaultOracle.getVaultUsdValue(RANDOM_USER);
        uint256 priceManual = yearnVaultOracle.getVaultUnderylingAssetsUsdValue(RANDOM_USER);
        assertApproxEqRel(price, priceManual, 1e14);
    }
}
