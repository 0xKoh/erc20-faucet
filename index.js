
    let accounts = null;
    let account = null;

    //Metamaskと接続する関数。

    const connect = async () => {
        if (typeof window.ethereum !== 'undefined') {
            try {
                accounts = await ethereum.request({ method: 'eth_requestAccounts' });
                const chainId = await ethereum.request({ method: 'eth_chainId' });
                await ethereum.request({ 
                    method: 'wallet_switchEthereumChain', 
                    params: [{ chainId: '0x5' }],
                });

                connectBtn.innerHTML = accounts[0];
                account = accounts[0].slice(2);
            } catch (error) {
                alert('トランザクションが拒否されました');
            }
        } else {
            alert('Metamaskをインストールしてください');
        }
    }

    let data = "";

    //コントラクトへトランザクションを行う際のdataを作成している関数。
    //withdraw関数の引数に渡すaccountとamountを256byteのhash値に変換している。

    const createData = () => {
        const zero = "0";
        let amount = document.getElementById("amount");
        amount = amount.value + zero.repeat(18);
        amount = parseInt(amount).toString(16);

        const zeros = 64 - amount.length;
        let addval = "";
        for(let i = 1; i <= zeros ; i ++){
            addval = addval += "0";
        }
        data = addval + amount;
        withdraw();
    }

    //コントラクトから数量を指定してトークンを貰う関数。

    const withdraw = async () => {
        try{
            await ethereum.request({
                method: 'eth_sendTransaction',
                params: [{
                            from: accounts[0],
                            to: 'コントラクトのアドレス',
                            gasLimit: '21000',
                            data: '0x06b091f9000000000000000000000000' + account + data,
                            chainId: 'チェーンのID', //コントラクトをデプロイしたチェーンをここに入れてください。
                        },
                    ],});
        } catch{
            alert('Metamaskと接続してください')
        }
    }

    //トークンを追加する関数。

    const addToken = async () => {
        await ethereum.request({
            method: 'wallet_watchAsset',
            params: {
                type: 'ERC20',
                options: {
                    address: 'トークンのアドレス', 
                    symbol: 'トークンのシンボル', 
                    decimals: 18, 
                    image: 'トークンの画像',
                },
            },
        })
    }

