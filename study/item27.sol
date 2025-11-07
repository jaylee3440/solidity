// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract item27 {
    ToDo[] todoList;

    struct ToDo {
        string text;
        bool complated;
    }

    function create(string calldata _text) external {
        ToDo memory sth = ToDo({text: _text, complated: false});
        todoList.push(sth);
    }

    function updataText(uint  _index, string calldata _text) external {
        todoList[_index].text = _text;
    }

    function complate(uint _index) external {
        todoList[_index].complated = true;
    }

    function get(uint _index) view external returns(ToDo memory){
        return todoList[_index];
    }
}
