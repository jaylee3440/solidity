// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract FunctionSelector{
    //
    function getSelector(string calldata _func) external pure returns(bytes4){
        return bytes4(keccak256(bytes(_func)));
    }

}

contract Receiver{

    event Log(bytes data);
    // input:
    //0xa9059cbb : 函数名及入参类型编码
    //0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4 :入参地址
    //000000000000000000000000000000000000000000000000000000000000007b :入参value
    function transfer(address addr, uint256 value) external {
        emit Log(msg.data);
    }
}