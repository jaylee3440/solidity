// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface MY_IERC20{
    /**
    * 当value单位的货币从from转移到to的时候
    */
    event Transfer(address indexed from, address indexed to, uint256 value);


    /**
    * 当value单位的货币从owner授权给spender的时候
    */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
    *  返回代币总数
    */
    function totalSupply() external view returns(uint256);
    
    /**
    *  返回account账户余额
    */
    function balanceOf(address account) external view returns(uint256);

    /**
    *  从msg.sender 账户转账到 to 账户 value 数量
    */
    function transfer(address to, uint256 value) external returns(bool);

    /**
    *  查询授信额度，即owner账户允许spender账户使用的额度
    */
    function allowance(address owner, address spender) external view returns(uint256);

    /**
    *  增加授信额度，即增加spender账户使用msg.sender账户的额度
    */
    function approve(address spender, uint256 value) external returns(bool);

    /**
    *  使用授信额度，使用from账户中msg.sender的授信额度转账给to账户amount
    */
    function transferFrom(address from, address to, uint256 amount) external returns(bool);
}

contract MY_ERC20 is MY_IERC20{

    uint256 private totalAmount;

    mapping(address => uint256) private  balanceMapping;

    mapping(address => mapping(address => uint256)) approvalMapping;

    string public name;
    string public symbol;
    uint public decimals = 18;


    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
    }

    function totalSupply() external view returns(uint256){
        return totalAmount;
    }

    function balanceOf(address account) external view returns(uint256){
        return balanceMapping[account];
    }

    function transfer(address to, uint256 value) external returns(bool){
        require(address(0) != to, "transfer to the zero address");
        require(balanceMapping[msg.sender] >= value, "insufficient balance");
        balanceMapping[msg.sender] -= value;
        balanceMapping[to] += value;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    function allowance(address owner, address spender) external view returns(uint256){
        return approvalMapping[owner][spender];
    }

    function approve(address spender, uint256 value) external returns(bool){
        approvalMapping[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external  returns(bool){
        require(approvalMapping[from][msg.sender] >= value, "approve insufficient balance");
        require(balanceMapping[from] >= value, "insufficient balance");
        approvalMapping[from][msg.sender] -= value;
        balanceMapping[from] -= value;
        balanceMapping[to] += value;

        emit Transfer(from, to, value);
        return true;
    }

    function mint(uint256 value) external returns(bool){
        balanceMapping[msg.sender] += value;
        totalAmount += value;
        return true;
    } 

    function burn(uint256 value) external {
        balanceMapping[msg.sender] -= value;
        totalAmount -= value;
    }


}