// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {IChainlink} from "./interface/IChainlink.sol";
import {ITriCrypto} from "./interface/ITriCrypto.sol";
import {IYearnVault} from "./interface/IYearnVault.sol";

contract YearnVaultOracle {
    address immutable chainlinkEth;
    address immutable chainlinkBtc;
    address immutable chainlinkUsd;
    address immutable triCrypto;

    constructor(address _chainlinkEth, address _chainlinkBtc, address _chainlinkUsd, address _triCrypto) {
        chainlinkEth = _chainlinkEth;
        chainlinkBtc = _chainlinkBtc;
        chainlinkUsd = _chainlinkUsd;
        triCrypto = _triCrypto;
    }

    function getVaultValueUsd(address addr) external view returns (uint256) {
        
    }

    function increment() public {
        number++;
    }
}
