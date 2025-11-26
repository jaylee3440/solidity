// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract uncheckKeywrod{

    /**
    unchecked : 节省gas
            场景： 已知数据范围的场景使用比如，require判断过数据大小，或者for循环中的i++
                环绕运算：
                举例：uint8 取值0-255，当数字溢出到256时会重新从0开始计数
    
    */

    // cost 791 gas 
    function add(uint x, uint y) external pure returns(uint){
        unchecked{
            return x + y;
        }
    }
    // cost 948 gas
    function add1(uint x, uint y) external pure returns(uint){
            return x + y;
         
    }

    // cost 813 gas 
    function sub(uint x, uint y) external pure returns(uint){
        unchecked{
            return x -y;
        }
    }

    
     // cost 926 gas
     function sub1(uint x, uint y) external pure returns(uint){
            return x -y;
     }
}