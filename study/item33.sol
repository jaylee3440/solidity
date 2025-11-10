// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
contract item33{

}



contract f {
    event f1(uint indexed _log1);
    event b1(uint indexed _log2);

    function foo(uint _logNumber) public virtual {
        emit f1(_logNumber);
    }
    function bar(uint _logNumber) public virtual {
        emit b1(_logNumber);
    }
}

contract s is f{

    event logs(uint indexed _logs1);
    event logb(uint indexed _logs2);

    function foo(uint _logNumber) override public virtual {
        emit logs(_logNumber);
        super.foo(_logNumber + 1);
    }

    function bar(uint _logNumber) override public virtual {
        emit logb(_logNumber);
    }
}

contract s1 is f{

    event logs1(uint indexed _logs1);
    event logb1(uint indexed _logb1);

    function foo(uint _logNumber) override public virtual {

        uint cache = _logNumber + 1;
        emit logs1(_logNumber * 3);
        super.foo(cache);
    }

    function bar(uint _logNumber) override public virtual {
        emit logb1(_logNumber);
    }
}





/*
    在继承时父类必须在子类左边

    当调用g.foo(5)时,执行线性化顺序 g->s1->s->f
    s1 emit(15) s emit(6) f emit(7)
    值得注意的一点是,执行s1的 super.foo()时,此时的执行的是s.foo,s的super.foo执行的是f.foo
    在整个调用链中,如果哪一环没有执行super方法,则调用中断

*/
contract g is s,s1{

    function foo(uint _logNumber) public override(s,s1) {
        super.foo(_logNumber);
    }

    function bar(uint _logNumber) public override(s,s1) {
        super.bar(_logNumber);
    }
}