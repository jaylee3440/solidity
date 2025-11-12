// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract HashContract{

    /** encode:     符合abi编码每个参数都填充32字节;
                    动态类型数据会增加长度前缀;
                    可以使用abi,decode解码
                    安全可靠使用范围广
        encodePacked:
                    不符合abi编码标准
                    数据紧密聚合无填充
                    可以解密
                    哈希冲突比较大
                    尽量少使用
        keccak256:
                    todo
    */
    function hash_encode(address addr, uint x, string memory str) public pure returns(bytes32){
        return keccak256(abi.encode(addr, x, str));
    }

    function hash_encodePacked(address addr, uint x, string memory str) public pure returns(bytes32){
        return keccak256(abi.encodePacked(addr, x, str));
    }

    function encode(address addr, uint x, string memory str) public pure returns(bytes memory){
        return abi.encode(addr, x, str);
    }

     function encodePacked(address addr, uint x, string memory str) public pure returns(bytes memory){
        return abi.encodePacked(addr, x, str);
    }
}