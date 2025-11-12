// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./item45.sol";

contract LibraryTest{
    // 需要背诵使用方式

    using ArrayUtils for uint[];
    uint [] public arr;

    function arrMax(uint[] memory _arr) pure public returns(uint){
        return _arr.max();
    }

    function arrMin(uint[] memory _arr) public pure returns(uint){
        return _arr.sum();
    }

    function max(uint x, uint y) public pure returns(uint){
        return Math.max(x, y);
    }

    function min(uint x, uint y) public pure returns(uint){
        return Math.min(x, y);
    }

}