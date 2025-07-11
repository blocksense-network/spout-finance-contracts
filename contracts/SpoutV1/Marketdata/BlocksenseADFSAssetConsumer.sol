// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ADFS} from "../blocksense/libraries/ADFS.sol";

abstract contract BlocksenseADFSAssetConsumer {
    address internal immutable ADFS_ADDRESS;
    uint256 internal immutable MIN_FRESHNESS;

    address public constant USD_ADDRESS =
        0x0000000000000000000000000000000000000348;

    error PriceTooOld(uint256 updatedAt);

    function getAssetPrice(uint256 feedId) public view returns (uint256) {
        bytes32 data = ADFS.getLatestSingleData(ADFS_ADDRESS, feedId);

        (uint256 price, uint256 updatedAt) = ADFS._decodeData(data);

        if (updatedAt < block.timestamp - MIN_FRESHNESS) {
            revert PriceTooOld(updatedAt);
        }

        return price;
    }
}
