// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract MutikCall{
    function fun1()external view returns(uint,uint){
        return (1,block.timestamp);
    }

      function fun2()external view returns(uint,uint){
        return (2,block.timestamp);
    }

    function getCallDate1() external pure returns(bytes memory){
        // return abi.encodeWithSignature("func1()");
        return abi.encodeWithSelector(this.fun1.selector);
    }

    function getCallData2() external pure returns(bytes memory){
        // return abi.encodeWithSignature("func2()");
        return abi.encodeWithSelector(this.fun2.selector);
    }
}

contract MutiCall{

    /**
    staticcall 是一种用于跨合约调用的低级函数，
        核心特点是：调用过程中不修改状态（只读操作），
        且仅能调用目标合约的 view 或 pure 函数（若调用非 view/pure 函数会报错）
    
    */
    function testCall(address[] memory _addr, bytes[] memory funData) external view returns(bytes[] memory){
        bytes[] memory result = new bytes[](funData.length);

        for (uint i; i < funData.length; i++) 
        {
            
            (bool l,bytes memory data) = _addr[i].staticcall(funData[i]);
            require(l,"tx fail");
            result[i] = data;
        }

        return result;
    }
}