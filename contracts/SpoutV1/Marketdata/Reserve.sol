// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {BlocksenseADFSAssetConsumer} from "./BlocksenseADFSAssetConsumer.sol";

contract Reserve is BlocksenseADFSAssetConsumer {
    // Blocksense ADFS Feed ID for LQD reserves
    // https://docs.blocksense.network/docs/data-feeds/feed/101001#pharos-testnet
    uint256 constant FEED_ID = 101001;

    // Get latest total reserves
    function getReserves() external view returns (uint256) {
        return getAssetPrice(FEED_ID);
    }
}
