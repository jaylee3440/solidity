// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract SignatureVerification {
    /**
    \x19 - 第一个字节，表示这是一个"有效消息"
    "Ethereum Signed Message:\n" - 固定字符串，标识这是以太坊签名消息
    "32" - 消息哈希的长度（32字节）
    
    */

    function verify(
        address signer,
        string memory msg,
        bytes memory sig
    ) external pure returns (bool) {
        bytes32 msgHash = getMsgHash(msg);
        bytes32 ethSignedMsgHash = getEthSignedMsgHash(msgHash);
        return recover(ethSignedMsgHash, sig) == signer;
    }

    function getMsgHash(string memory msg) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(msg));
    }

    function getEthSignedMsgHash(
        bytes32 msgHash
    ) private pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", msgHash)
            );
    }

    function recover(bytes32 ethSignedMsgHash, bytes memory sig) public pure returns(address){
       (bytes32 r, bytes32 s, uint8 v) = splitSignature(sig);
        return ecrecover(ethSignedMsgHash, v, r, s);
    }

    function splitSignature(
        bytes memory sig
    ) public pure returns (bytes32  r, bytes32  s, uint8 v) {
        require(sig.length == 65, " require sig length equlas 65");
        assembly{
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
}
