// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract item36{

    address payable  public  addr;

    constructor(){
       addr = payable (msg.sender);
       // addr = msg.sender;
    }

    function receiveETH() payable  external  {

    }

    /**
        接受纯ETH转账
    */
    receive() external payable { }

    function getBanlance() public view returns(uint256){
        return addr.balance;
    }

    function getThisBalance() external view returns(uint256){
        return address(this).balance;
    }

    fallback() external payable {
        revert("receive eth fail");
     }
}

contract sendEth{

    function send(address payable   _addr,uint amount) external {
        _addr.call{value: amount}("");
    }
}