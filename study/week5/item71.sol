// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
    总体思路是用总的奖励金额/总质押金额 计算出奖励汇率

    主要方法：   提现（提现质押金额）
                质押（质押金额）
                获取奖励（用户提取自己质押金额获得的奖励）
                补充奖励（管理员增加总奖励金额）
                计算全局奖励汇率 
                查看个人奖励金额 earned

*/
contract  StakingReward{

    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken;
    address public owner;

    uint256 public endAt; // 质押活动结束时间
    uint256 public uptAt; // 质押活动修改时间
    uint256 public duration; // 持续时间
    uint256 public gloabRate; // 全局汇率
    mapping (address => uint256) public userRates; // user汇率
    mapping (address => uint256) public userRewards; // user的奖励金额
    mapping (address => uint256) public userBalances; // user质押金额
    uint256 public rewardRate; // 每秒奖励金额
    uint256 public totalSupply; // 总质押金额

    constructor(address _stakingToken, address _rewardToken, uint256 _duration) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
        duration = _duration;
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(owner == msg.sender, "not owner");
        _;
    }

    modifier updateReward(address addr){
        if(totalSupply != 0){
            gloabRate += (rewardRate * (minTime() - uptAt) * 1e18 / totalSupply);
            uptAt = minTime();

            if(addr != address(0)){
                userRewards[addr] = earned(addr);
                userRates[addr] = gloabRate;
            }
        }
        _;
    }

    // 计算用户奖励 用户质押金额 * （总汇率-用户已经获取的汇率）
    function earned(address _addr) public view returns(uint256){
        uint256 userRate = userRates[_addr];    
        return userRewards[_addr] + (gloabRate - userRate) * userBalances[_addr] / 1e18;
    }

    function minTime() private view returns(uint256){
        return block.timestamp > endAt ? endAt : block.timestamp;
    }

    // 质押
    function staking(uint256 _amount) public updateReward(msg.sender) {
        require(_amount > 0, "amount error");
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        userBalances[msg.sender] += _amount;
        totalSupply += _amount;
        
    }

    function withdraw(uint256 _amount) public updateReward(msg.sender){
        require(_amount > 0, "amount error");
        require(userBalances[msg.sender] >= _amount, "amount error");
        stakingToken.transfer(msg.sender, _amount);
        userBalances[msg.sender] -= _amount;
        totalSupply -= _amount;
    }

    function getReward() external updateReward(msg.sender) {
        uint256 amount = userRewards[msg.sender];
        userRewards[msg.sender] = 0;
        rewardToken.transferFrom(address(this), msg.sender, amount);
    }
    
    // 管理员增加总奖励金额
    function notifyRewardAmount(uint256 amount) external onlyOwner updateReward(address(0)){
        if(block.timestamp > endAt){
            rewardRate = amount / duration;
          
        }else{
            rewardRate = ((endAt - block.timestamp) * rewardRate + amount) / duration;

        }

        require(rewardRate > 0, "");
        require(duration * rewardRate <= rewardToken.balanceOf(address(this)), " ");

        
        endAt = block.timestamp + duration;
        uptAt = block.timestamp;


    }


}