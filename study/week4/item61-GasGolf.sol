// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract GasGolf{
    /**

        优化gas的方式：
            1.calldata 代替 memory
            2.在循环内修改状态变量的，先将状态变量加载到内存中，循环完之后在写回去
            3.用++i来替代i+1
            4.对频繁访问的数组元素，将元素加载到内存
            
        
        [1,2,4,6,86,9,0,3]
    */

    uint256 public total;
    // 58954 -> 56463 
    function sum(uint256[] memory arr) external {

        for (uint i; i< arr.length; i ++) 
        {
            if(arr[i] % 2 == 0){
                total ++;
            }
        }
    }
    // 57995
    function sum1(uint256[] memory arr) external {

        uint _total = total;
        for (uint i; i< arr.length; i ++) 
        {
            if(arr[i] % 2 == 0){
                _total ++;
            }
        }
        total = _total;
    }

 // 58156 
    function sum2(uint256[] memory arr) external {

        uint _total = total;
        for (uint i; i< arr.length; i ++) 
        {
            uint256 num = arr[i];
            if(num % 2 == 0){
                _total ++;
            }
        }
        total = _total;
    }
}