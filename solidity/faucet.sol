// SPDX-License-Identifier: UNLISCENSED
pragma solidity ^0.8.4;

interface ERC20 {
    
    function balanceOf(address account) external view returns (uint256);

    function decimals() external view returns (uint8);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
 
}

contract Faucet {
    
    ERC20 token;
    
    address owner;

    uint256 value;

    uint256 limit;

    
    constructor (address _tokenAddress, address _ownerAddress, uint256 _value, uint256 _limit) {
        token = ERC20(_tokenAddress);
        owner = _ownerAddress;
        value = _value;
        limit = _limit;
    }   
    
    modifier onlyOwner{
        require(msg.sender == owner, "Error: It is not the address of the administrator.");
        _;
    }
    
    function variableSend(uint256 _amount) external {
        require(token.balanceOf(address(this)) >= _amount, "Error: There is no balance in Faucet.");
        require(limit >= _amount, "Error: The maximum amount that can be withdrawn has been exceeded.");
        
        token.transfer(msg.sender, _amount * 10**token.decimals());
    }
        
    function constantSend() external {
        require(token.balanceOf(address(this)) >= value, "Error: There is no balance in Faucet.");
        token.transfer(msg.sender, value * 10**token.decimals());
    }

    function setTokenAddress(address _addToken) external onlyOwner {
        token = ERC20(_addToken);
    }    

    function setFaucetAmount(uint256 _amount) external onlyOwner {
        value = _amount;
    }

    function setLimit(uint256 _amount) external onlyOwner {
        limit = _amount;
    }  
     
    function withdrawTokens(address _receiver, uint256 _amount) external onlyOwner {
        require(token.balanceOf(address(this)) >= _amount, "Error: There is no balance in Faucet.");
        token.transfer(_receiver,_amount);
    }
}