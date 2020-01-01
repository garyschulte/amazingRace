# amazing race mvp

## todo:
* race owner authz function, utilizing RaceMarker Root node secret
* race lifecycle:
  * start race (state)
  * complete race (state)
  * abort race (state)
  * gc races (reclaim state)
* zero knowledge proofs for authz and proving


## MVP
### compile with truffle
`truffle compile`

### deploy to ganache
`truffle migrate`

### test it out
get one of the accounts with ether:
    `let accounts = await web3.eth.getAccounts()`

get the contract address:
    `let ar = await mvp.deployed()`

call prove on a secret:
    `ar.prove.call("pacific city", {from: accounts[0]})`

generate the keccak256 hash of a new string 
    `ar.keccak256helper("something else")`


