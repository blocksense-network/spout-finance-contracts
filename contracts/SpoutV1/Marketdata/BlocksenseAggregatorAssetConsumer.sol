// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ICLAggregatorAdapter} from "../blocksense/interfaces/ICLAggregatorAdapter.sol";

abstract contract BlocksenseAggregatorAssetConsumer {
    uint256 internal immutable MIN_FRESHNESS;

    error PriceTooOld(uint256 updatedAt);

    function getAssetPrice(address clAdapter) public view returns (uint256) {
        (, int256 price, , uint256 updatedAt, ) = ICLAggregatorAdapter(
            clAdapter
        ).latestRoundData();

        if (updatedAt < block.timestamp - MIN_FRESHNESS) {
            revert PriceTooOld(updatedAt);
        }

        return uint256(price);
    }
}
