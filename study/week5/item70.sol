// SPDX-License-Identifier: MIT
pragma solidity ^0.8;


contract item70{

    function test(uint a, uint b, address add, bytes calldata bytess) public pure{

    }

    function test1() public view{
        test({
            a:23,
            add: msg.sender,
            bytess: msg.data,
            b:34
        });
    }
}