// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract DecodeContract{

    struct MyStruct{
        string name;
        uint age;
    }

    function encodeData(uint _i, string memory _str, address _addr, MyStruct memory _my) external pure returns(bytes memory){
        return abi.encode(_i,_str, _addr,_my);
    }

    function decodeData(bytes memory _data) external pure returns(uint _i, string memory _str, address _addr, MyStruct memory _my){
         (_i, _str, _addr, _my) = abi.decode(_data, (uint, string , address , MyStruct));
    }

    receive() external payable { }
}

