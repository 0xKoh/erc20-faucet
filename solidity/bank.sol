// SPDX-License-Identifier: UNLISCENSED
pragma solidity ^0.8.4;

contract bank {

    mapping(address => uint) balance;

    function deposit() payable public {
        balance[msg.sender] += msg.value;
    }

    function transfer(address _account, uint _amount) public {
        require(balance[msg.sender] >= _amount, "BankError: The balance is in excess of the balance.");
        balance[msg.sender] -= _amount;
        balance[_account] += _amount;
    }
    
    function withdraw(uint _amount) public {
        require(balance[msg.sender] >= _amount, "BankError: The balance is in excess of the balance.");
        balance[msg.sender] - _amount;
        payable(msg.sender).transfer(_amount);
    }
}
