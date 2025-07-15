// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IReserve
 * @dev Interface for the Reserve contract to be used by automation and other contracts
 */
interface IReserve {
    /**
     * @dev Get the latest total reserves amount
     * @return The total  reserves amount (scaled to 6 decimals)
     */
    function getReserves() external view returns (uint256);
}
