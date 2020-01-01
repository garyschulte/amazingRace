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

### test it out in its current state
get one of the accounts with ether:
    `let accounts = await web3.eth.getAccounts()`

get the contract address:
    `let ar = await mvp.deployed()`

generate the keccak256 hash of a new string 
    `ar.keccak256helper("secret")`

create a race:
    `ar.createRace("test", "0x65462b0520ef7d3df61b9992ed3bea0c56ead753be7c8b3614e0ce01e4cac41b", "this should normally be encrypted hint text", {from: accounts[0], value: 1000000000000000000})`

call prove on a secret:
    `ar.prove("test", 1, "secret", {from: accounts[0]})`

  or, to see the return:    
    `ar.prove.call("test", 1, "secret", {from: accounts[0]})`




