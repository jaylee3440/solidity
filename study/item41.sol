// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract item41{



}


interface ICounter {
    
    function getCount() view external returns(uint);

    function increment() external ;

}

/**
    调用其他合约时,可以定义接口的方式来调用,但是函数列表要和远程保持一致
    初始化时要知道远程合约的地址


*/
contract counter{
    ICounter public iCounter;
    uint public count;

    constructor(address _address){
        iCounter = ICounter(_address);
    }

    function incrementCount() external {
        iCounter.increment();
    }

    function getCount() view external returns(uint){
        return iCounter.getCount();
    }

}