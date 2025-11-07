// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
contract item26{

        string  text;
        /*
            external:
                calldata:存储在交易调用的数据中，不可改，不占用内存（作为参数传递时传递指针）消耗的gas更低
                memory: 需要将参数复制到内存中，然后在执行函数，参数越大，成本越高
            internal:
                calldata: 读取成本低，访问内部的某个元素成本是固定的，比访问memory稍高
                memory: 第一次使用成本很高，evm需要扩展内存。后续读写比calldata便宜
            storage:
                数据永久存储在链上，读取写入成本最高，尽量使用memory缓存，一次读写

        */
     
        function setText(string memory _text) public {

            text = _text;
        }

        // memory 3328 gas

        function getText() view internal returns(string memory){
            return  text;
        }
}