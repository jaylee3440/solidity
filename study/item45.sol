// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

library Math {
    function min(uint x, uint y) public pure returns (uint) {
        return x > y ? y : x;
    }

    function max(uint x, uint y) public pure returns (uint) {
        return x > y ? x : y;
    }
}

library ArrayUtils {
    function sum(uint[] memory uarr) public pure returns (uint) {
        uint result;
        if (uarr.length == 0) {
            return result;
        }

        for (uint i = 0; i < uarr.length; i++) {
            result += uarr[i];
        }
        return result;
    }

    function max(uint[] memory uarr) public pure returns (uint) {
        uint result;
        if (uarr.length == 0) {
            return result;
        }
        for (uint i = 0; i < uarr.length; i++) {
            if (uarr[i] > result) {
                result = uarr[i];
            }
        }
        return result;
    }
}

