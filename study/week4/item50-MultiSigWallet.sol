// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract MultiSigWallet{

    struct Transcation{
        address payable to;
        uint256 value;
        bytes data;
        bool executed;       
    }

    address[] public ownerArr;
    mapping(address=>bool) public isOwner;
    Transcation[] public transcations;
    mapping(uint256=>mapping (address=>bool)) public votes;
    uint256 public requireVotes;

    constructor(address[] memory _owners, uint256 _requireVotes){
        require(_owners.length > 5,"_owners length must > 5");
        for (uint i = 0; i < _owners.length; i++){
            require(_owners[i] != address(0),"has address zero");
            ownerArr.push(_owners[i]);
            isOwner[_owners[i]] = true;
        }

        requireVotes = _requireVotes;
    }

    modifier onlyOwner(){
        require(isOwner[msg.sender], "no auth");
        _;
    }

    modifier existTx(uint256 index){
        require(index < transcations.length, "no tx");
        _;
    }

    modifier notFinish(uint256 index){
        require(!transcations[index].executed, " is finish");
        _;
    }


    function submit(address payable _to, uint256 _value, bytes calldata _data)external onlyOwner{
        require(_to != address(0), "has zero address");
        transcations.push(Transcation({
            to:_to,
            value:_value,
            data:_data,
            executed: false
        }));
    }

    function vote(uint256 index)external onlyOwner existTx(index) notFinish(index) returns(bool){
        votes[index][msg.sender] = true;
        return true;
    }

    function revertVote(uint256 index)external onlyOwner existTx(index) notFinish(index) returns(bool){
        votes[index][msg.sender] = false;
        return true;
    }

    function submit(uint256 index)external existTx(index) notFinish(index)returns(bool){
        require(_getVoteNumber(index) >= requireVotes, "votes not enough");

        Transcation memory t = transcations[index];
        t.executed = true;
        (bool b,) = t.to.call{value: t.value}(t.data);
        require(b, 'tx fail');
        return b;
    }

    function _getVoteNumber(uint256 index) private view returns(uint256){
        uint256 voteNumber;
        for(uint i = 0; i < ownerArr.length; i ++){
            if(votes[index][ownerArr[i]]){
                voteNumber ++;
            }
        }
        return voteNumber;
    }
}
