# amazing race mvp

## todo:
* track players and deposits 
* race lifecycle:
  * add waypoints
  * start race (state)
  * finish race (state)
  * abort race (state)


* enable multiple races
  * create race
  * deposit threshold to start race
  * gc races (reclaim state)


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
    `ar.gimmie("something else")`


