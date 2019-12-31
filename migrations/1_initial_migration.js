// const Migrations = artifacts.require("Migrations");
const mvp = artifacts.require("mvp");

module.exports = function(deployer) {
  // deployer.deploy(Migrations);
  deployer.deploy(mvp);
};
