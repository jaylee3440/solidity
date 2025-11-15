// SPDX-License-Identifier: MIT
pragma solidity ^0.8;


import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract DucthAuction is Ownable , ReentrancyGuard{

    // nft
    IERC721 public immutable nft;
    uint256 public immutable nftId;

    uint256 public immutable startPrice; // 初始价
    uint256 public immutable floorPrice; // 最低价
    uint256 public immutable duration; // 拍卖时长
    uint256 public immutable decreaseRate; // 价格递减速率（wei/秒）
    uint256 public immutable startDate; // 拍卖开始时间
    uint256 public immutable endDate; // 拍卖结束时间
    address public winner; // 拍卖成功
    bool public auctionEnded; // 拍卖是否结束

    // 拍卖开始事件
    event auctionStarted(
        address indexed nftContract,
        uint256 indexed nftId,
        uint256 startPrice,
        uint256 floorPrice,
        uint256 duration
    );

    // 流拍事件
    event auctionCancelled();

    // 拍卖成功
    event auctionSuccessful(
        address indexed winner, 
        uint256 indexed finalPrice
    );

    constructor(
        address _nft,
        uint256 _nftId,
        uint256 _startPrice,
        uint256 _floorPrice,
        uint256 _duration
    ) Ownable(msg.sender){
        nft = IERC721(_nft);
        nftId = _nftId;
        startPrice = _startPrice;
        floorPrice = _floorPrice;
        duration = _duration;
        decreaseRate = (_startPrice - _floorPrice) / _duration;
        startDate = block.timestamp;
        endDate = startDate + _duration;

        nft.transferFrom(msg.sender, address(this), _nftId); // 将nftId转移到合约
        emit auctionStarted(_nft, _nftId, _startPrice, _floorPrice, _duration);
    }

    // 购买nfc
    function buy() external payable returns(bool){
        require(!auctionEnded, "auction is end");
        require(block.timestamp > startDate, "auction is not start");
        require(block.timestamp < endDate, "auction is end");
        require(msg.value >= getCurrentPrice(), "msg value less current price");
        auctionEnded = true;
        winner = msg.sender;
    
        nft.transferFrom(address(this), msg.sender, nftId);
        emit auctionSuccessful(msg.sender, getCurrentPrice());

        return true;
    }

    function getCurrentPrice() private view returns(uint256){
        if(block.timestamp > endDate) return floorPrice;
        if(block.timestamp < startDate) return startPrice;
       return  startPrice - (block.timestamp - startDate) * decreaseRate < floorPrice ? floorPrice : startPrice - (block.timestamp - startDate) * decreaseRate;
    }

    function withdrawFunds() external onlyOwner nonReentrant{
        require(auctionEnded, "not end");
        payable (address(this)).call{value: address(this).balance}("");
    }

    receive() external payable { }


}