// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract BitwiseOperator{

 // & and 二进制位都是1返回1 否则返回0
 function and() public pure returns(uint){
    return 12 & 12;
 }
 // | 二进制位有一个是1返回1 否则返回0
 function or() public pure returns(uint256){
    return 12 | 12;
 }

 // ^ 二进制位有且仅有一个是1是返回1 否则返回0
 function xor() public pure returns(uint256){
    return 12 ^ 12;
 }

 // ~ not 1变0 0变1
 function not(uint8 x) public pure returns(uint256){
    return ~ x;
 }  
 // left 二进制位左移 即 *2
 function left() public pure returns(uint256){
    return 11 << 2;
 }

 // right 二进制位右移 即/2     1011
 function right() public pure returns(uint){
    return 11 >> 2;
 }

}