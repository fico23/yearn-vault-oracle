// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {IChainlink} from "./interface/IChainlink.sol";
import {ITriCrypto} from "./interface/ITriCrypto.sol";
import {IYearnVault} from "./interface/IYearnVault.sol";
import {FixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";

error OldPrice();
error InvalidPrice();

contract YearnVaultOracle {
    uint256 private constant USDT_OLD_THRESHOLD = 2 days;
    uint256 private constant ETH_BTC_OLD_THRESHOLD = 1 hours;

    uint256 private constant TRI_CRYPTO_USDT_INDEX = 0;
    uint256 private constant TRI_CRYPTO_BTC_INDEX = 1;
    uint256 private constant TRI_CRYPTO_ETH_INDEX = 2;

    address private immutable chainlinkEth;
    address private immutable chainlinkBtc;
    address private immutable chainlinkUsdt;
    address private immutable triCrypto;
    address private immutable yearnVault;

    constructor(
        address _chainlinkEth,
        address _chainlinkBtc,
        address _chainlinkUsdt,
        address _triCrypto,
        address _yearnVault
    ) {
        chainlinkEth = _chainlinkEth;
        chainlinkBtc = _chainlinkBtc;
        chainlinkUsdt = _chainlinkUsdt;
        triCrypto = _triCrypto;
        yearnVault = _yearnVault;
    }

    function getVaultUsdValue(address addr) external view returns (uint256) {
        return IYearnVault(yearnVault).balanceOf(addr) * IYearnVault(yearnVault).pricePerShare() / 1e18
            * ITriCrypto(triCrypto).get_virtual_price() * 3
            * FixedPointMathLib.cbrt(
                getCLPrice(chainlinkBtc, ETH_BTC_OLD_THRESHOLD) * getCLPrice(chainlinkEth, ETH_BTC_OLD_THRESHOLD)
                    * getCLPrice(chainlinkUsdt, USDT_OLD_THRESHOLD) * 1e30
            ) / 1e36;
    }

    function getVaultUnderylingAssetsUsdValue(address addr) external view returns (uint256) {
        uint256 usdtBalance = ITriCrypto(triCrypto).balances(TRI_CRYPTO_USDT_INDEX);
        uint256 btcBalance = ITriCrypto(triCrypto).balances(TRI_CRYPTO_BTC_INDEX);
        uint256 ethBalance = ITriCrypto(triCrypto).balances(TRI_CRYPTO_ETH_INDEX);

        uint256 totalSupply = IERC20(ITriCrypto(triCrypto).token()).totalSupply();

        uint256 poolValue = usdtBalance * getCLPrice(chainlinkUsdt, USDT_OLD_THRESHOLD) * 1e12
            + btcBalance * getCLPrice(chainlinkBtc, ETH_BTC_OLD_THRESHOLD) * 1e10
            + ethBalance * getCLPrice(chainlinkEth, ETH_BTC_OLD_THRESHOLD);

        return IYearnVault(yearnVault).balanceOf(addr) * IYearnVault(yearnVault).pricePerShare() / 1e18 * poolValue
            / totalSupply / 1e8;
    }

    function getCLPrice(address feed, uint256 oldTreshold) internal view returns (uint256) {
        (, int256 price,, uint256 updatedAt,) = IChainlink(feed).latestRoundData();
        unchecked {
            if (updatedAt < block.timestamp - oldTreshold) revert OldPrice();
        }

        if (price < 1) revert InvalidPrice();

        return uint256(price);
    }
}
