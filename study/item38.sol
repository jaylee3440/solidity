// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract item38{



    /**
    构造方法必须有payable,方法上必须有payable关键字，转账的地址必须是payable

    transfer: revert 2300gas
    send: return bool 2300gas 较少使用
    call: all gas, return bool and bytes

    transfer：简单、自动抛出异常，推荐用于安全、简单的 Ether 转账。
    send：灵活，但需要手动检查错误。通常不推荐，除非你确实需要处理失败时的逻辑。
    call：最灵活，适用于复杂的场景，但也是最危险的。要小心使用，确保做好错误处理和重入攻击防范。
    
    
    
    
    */
    constructor() payable {

    }

    fallback() external payable { } 
    receive() external payable { }

    function callEth(address payable  _to) external payable  returns(bytes memory){
        (,bytes memory data) = _to.call{value:123}("");
        return data;
    }

    function transferEth(address payable  _to) payable  external {
        _to.transfer(123);
    }

    function sendEth(address payable  _to) payable  external returns(bool){
       bool b =  _to.send(123);
       return b;
    }
}