// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {BlocksenseAggregatorAssetConsumer} from "../Marketdata/BlocksenseAggregatorAssetConsumer.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Orders is Ownable, BlocksenseAggregatorAssetConsumer {
    event BuyOrderCreated(
        address indexed user,
        string ticker,
        address token,
        uint256 usdcAmount,
        uint256 assetAmount,
        uint256 price
    );
    event SellOrderCreated(
        address indexed user,
        string ticker,
        address token,
        uint256 usdcAmount,
        uint256 assetAmount,
        uint256 price
    );
    event AgentUSDCWithdraw(address indexed user, uint256 amount);

    address public immutable AGENT;
    IERC20 public immutable USDC_TOKEN;

    constructor(
        address _owner,
        address _agent,
        address _usdc,
        uint256 _minFreshness
    ) {
        _transferOwnership(_owner);
        AGENT = _agent;
        USDC_TOKEN = IERC20(_usdc);
        MIN_FRESHNESS = _minFreshness;
    }

    modifier onlyAgent() {
        require(msg.sender == AGENT, "Only agent can call this function");
        _;
    }

    // Buy asset with USDC by getting price from oracle
    function buyAsset(
        address clAdapter,
        string memory ticker,
        address token,
        uint256 usdcAmount
    ) public {
        // Transfer USDC from user to contract
        USDC_TOKEN.transferFrom(msg.sender, address(this), usdcAmount);

        // Get price from oracle
        uint256 price = getAssetPrice(clAdapter);

        // Calculate asset amount (adjust decimals as needed)
        uint256 assetAmount = (usdcAmount * 1e18) / price;

        // Emit event
        emit BuyOrderCreated(
            msg.sender,
            ticker,
            token,
            usdcAmount,
            assetAmount,
            price
        );
    }

    // Sell asset for USDC by getting price from oracle
    function sellAsset(
        address clAdapter,
        string memory ticker,
        address token,
        uint256 tokenAmount
    ) public {
        // Get price from oracle
        uint256 price = getAssetPrice(clAdapter);

        // Calculate USDC amount (adjust decimals as needed)
        uint256 usdcAmount = (tokenAmount * price) / 1e18;

        // Emit event
        emit SellOrderCreated(
            msg.sender,
            ticker,
            token,
            usdcAmount,
            tokenAmount,
            price
        );
    }

    function withdrawUSDC(uint256 amount) public onlyAgent {
        USDC_TOKEN.transfer(msg.sender, amount);
        emit AgentUSDCWithdraw(msg.sender, amount);
    }
}
