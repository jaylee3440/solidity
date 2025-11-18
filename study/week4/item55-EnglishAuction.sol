// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract EnglishAuction{

    IERC721 immutable public nft; //
    uint256 immutable public nftId;
    uint256 immutable public startTime;
    uint256 immutable public endTime;
    uint256 immutable public startPrice;
    address immutable public owner; // 合约部署方，抽佣
    address immutable public seller; // 卖方
    uint256 immutable public minBidIncrement; // 最小加价幅度
    uint256 immutable public commissionRate; // 抽佣比例

    address public highestBidder; // 当前最高人地址
    uint256 public highestPrice; // 当前最高价

    uint256 immutable public depositAmount; // 保证金
    mapping(address=> bool) public hasDeposited; // 是否缴纳保证金
    mapping(address => uint256) public bidderBalances; // 保证金列表
    address[] public bidderList; // 竞买人集合

    enum AuctionStatusEnum{ NOT_STARTED, ONGOING, ENDED, SETTLED}

    AuctionStatusEnum public currentStatus;

    event AuctionStarted(uint256 startTime, uint256 endTime, uint256 tokenId);
    event BidPlanced(address indexed bidder, uint256 indexed bidAmount, uint256 tokenId); // 竞价
    event AuctionEnded(address indexed highestBidder, uint256 highestPrice, uint256 tokenId); // 竞价结束
    event AuctionSettled(address indexed highestBidder, uint256 settleTime, uint256 commission, uint256 nftId); // 结算
    event DepositRefunded(address indexed addr, uint256 price); // 退保证金
    event NFTLocked(address nftOwner, uint256 nftTokenId);

    modifier onlyOwner(){
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier notStarted(){
        require(currentStatus == AuctionStatusEnum.NOT_STARTED, "auction already started");
        _;
    }

    modifier ongoing(){
        require(currentStatus == AuctionStatusEnum.ONGOING
            && block.timestamp > startTime
            && block.timestamp < endTime ,
            "auction not ongoing"
        );
        _;
    }

    modifier endedNotSettle(){
        require(currentStatus == AuctionStatusEnum.ENDED
            && block.timestamp > endTime
            , " acution not settle or already settle"
        );
        _;
    }

    constructor(
        address _seller,
        address _nft,
        uint256 _nftId,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _minBidIncrement,
        uint256 _commissionRate,
        uint256 _depositAmount
    ){
        seller = _seller;
        nft = IERC721(_nft);
        nftId = _nftId;
        startTime = _startTime;
        endTime = _endTime;
        minBidIncrement = _minBidIncrement;
        commissionRate = _commissionRate;
        depositAmount = _depositAmount;
        currentStatus = AuctionStatusEnum.NOT_STARTED;

        nft.transferFrom(seller, msg.sender, nftId);

        emit NFTLocked(seller, nftId);

    }

    // 开始拍卖
    function startAcution() onlyOwner external {
        currentStatus = AuctionStatusEnum.ONGOING;
        emit AuctionStarted(startTime, endTime, nftId);
    } 

    // 缴纳保证金
    function deposit() external payable {
        require(msg.value == depositAmount, "deposit amount not enough" );
        require(!hasDeposited[msg.sender], "already pay deposit");
        hasDeposited[msg.sender] = true;
        bidderBalances[msg.sender] += depositAmount;
        bidderList.push(msg.sender); 
    }

    // 竞价（需要缴纳保证金）
    function placeBid() external ongoing payable {
        require(hasDeposited[msg.sender], "");
        require(msg.value > highestPrice, "");
        require(msg.value - highestPrice > minBidIncrement, "");
        // 退还上一轮出价
        if(highestBidder != address(0)){
           (bool l,) = highestBidder.call{value: highestPrice}("");
           require(l, "call fail");
           emit DepositRefunded(highestBidder, highestPrice);
        }

        // 修改最高竞价人信息
        highestBidder = msg.sender;
        highestPrice = msg.value;

        emit BidPlanced(msg.sender, msg.value, nftId);
        
    }

    // 结束拍卖
    function endAuction() external onlyOwner{

        require(block.timestamp > endTime, "");
        require(AuctionStatusEnum.ONGOING == currentStatus,"");
        currentStatus = AuctionStatusEnum.ENDED;

        emit AuctionEnded(highestBidder, highestPrice, nftId);
    }

    // 结算
    function settle() external onlyOwner endedNotSettle{
        // 1 计算佣金和支付给seller的金额
        uint256 commissionAmount = highestPrice * commissionRate;
        uint256 sellNFTAmount = highestPrice - commissionAmount;
        // 2 转移nft给出价最高者
        nft.transferFrom(owner, highestBidder, nftId);

        // 3 转移金额给seller
        (bool b, ) = seller.call{value: sellNFTAmount}("");

        // 4 转移佣金给owner
        (bool b1, ) = owner.call{value: commissionAmount}("");

        // 5 退还最高出价保证金

        // 6 退还所有未成交人的保证金
        for(uint i = 0; i < bidderList.length; i++ ){
           address bidder =  bidderList[i];
           if(hasDeposited[bidder]){
            bidder.call{value: bidderBalances[bidder]}(""); 
           }
           
        }

        // 7 更新拍卖状态为已结算
        currentStatus = AuctionStatusEnum.SETTLED;
        emit  AuctionSettled(highestBidder, block.timestamp, commissionAmount, nftId);
    }

    function refundDeposit() external payable {
        require(block.timestamp < startTime || block.timestamp > endTime, "");
        require(hasDeposited[msg.sender],"");
        hasDeposited[msg.sender] = false;

        uint256 amount = bidderBalances[msg.sender];
        bidderBalances[msg.sender] = 0;

        payable (msg.sender).call{value: amount}("");

    }

    receive() external payable { }  
}