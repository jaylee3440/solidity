// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Counter{
    uint public count;

    function increment() external {
        count ++;
    }

    function getCount() view  external returns(uint){
        return count;
    }
}