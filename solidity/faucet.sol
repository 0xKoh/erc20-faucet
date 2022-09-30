// SPDX-License-Identifier: UNLISCENSED
pragma solidity ^0.8.4;

interface ERC20 {
    
     /**
     ERC20からbalanceOf関数(引数にアドレスを渡すことでその人の残高を取得することのできる関数)の読み込みを行い、
     testTokenFaucetコントラクトで使用できるようにしている。
     */
    function balanceOf(address account) external view returns (uint256);

     /**
     ERC20からdecimals関数(発行されているトークンの小数点以下の桁数を返す関数)の読み込みを行なっている。
     */
    function decimals() external view returns (uint8);

    /**
     ERC20からtransfer関数(引数にaddressとamountを指定することでトークンを送金することのできる関数)の読み込みを行なっている。
     transferが成功するとboolが返ってくる。
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
 
}

contract testTokenFaucet {
    
    // interfaceで読み込んだERC20オブジェクトのメソッド群をtoken(オブジェクト)に格納している。
    ERC20 token;
    
    // オーナーのアドレスが代入される変数の定義
    address owner;
    
    // タイムスタンプとアドレスを紐付けた連想配列
    mapping(address=>uint256) nextRequestAt;
    
    // send関数(トークンを引数に入ったアドレスへ送る関数)で使用されている変数で、送信するトークンの量を定義している。
    uint256 faucetDripAmount = 100;
    
    /** 
    このconstructor内の処理はコントラクトをデプロイするときに実行される。変数や関数などを定義することができる。
    */
    constructor (address _tokenAddress, address _ownerAddress) {
        token = ERC20(_tokenAddress);
        owner = _ownerAddress;
    }   
    
    // onlyOwner修飾子のついている関数はその処理の前にこのonlyOwnerに処理が飛ぶ。関数を叩いた人がコントラクトをデプロイした人か確かめている。
    modifier onlyOwner{
        require(msg.sender == owner,"FaucetError: Caller not owner");
        _;
    }    
    
    //** この関数を叩くことでトークンが振り込まれる。*//

    function send() external {
        require(token.balanceOf(address(this)) > 1,"FaucetError: Empty");
        // 前回関数を叩いた時間から5分経過しているか確かめている。
        require(nextRequestAt[msg.sender] < block.timestamp, "FaucetError: Try again later");
        
        nextRequestAt[msg.sender] = block.timestamp + (5 minutes); 
        token.transfer(msg.sender,faucetDripAmount * 10**token.decimals());
    }  

     /** オーナーのみがFaucetで取り扱うトークンをセットすることのできる関数。*/
     function setTokenAddress(address _addToken) external onlyOwner {
        token = ERC20(_addToken);
    }    
    
     /** faucetDripAmount変数に格納されている値を_amountへ渡している。 */

     function setFaucetDripAmount(uint256 _amount) external onlyOwner {
        faucetDripAmount = _amount;
    }  
     
     
     /** 
     onlyOwner修飾子がついているので、オーナーしか叩くことができない。Faucetコントラクトからトークンを出金する為の関数。
     */ 
     function withdrawTokens(address _receiver, uint256 _amount) external onlyOwner {
        require(token.balanceOf(address(this)) >= _amount,"FaucetError: Insufficient funds");
        token.transfer(_receiver,_amount);
    }
}