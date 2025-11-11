// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract item37 {


    /**
        直接发送eth 判断msg.data是否存在
        存在 - fallback 
        不存在 - 走receive 如果receive不存在 - 走fallback
    
    
    */
    event callerFallback(
        address indexed _addr,
        uint256 indexed _amount,
        bytes indexed _data
    );

    event callerReceive(address indexed _addr, uint256 indexed _amount);

    fallback() external payable {
        emit callerFallback(msg.sender, msg.value, msg.data);
    }

    receive() external payable { 
        emit callerReceive(msg.sender, msg.value);
    }

    function getBalance() view external returns(uint256){
        return address(this).balance;
    }
}
