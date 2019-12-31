pragma solidity >=0.4.21 <0.7.0;

import "./ERC165.sol";
import "./AmazingRace.sol";

contract mvp is AmazingRace, ERC165Mappable {

  uint8 constant RETURN_NOT_FOUND = 0;
  uint8 constant RETURN_UNPROVEN = 1;
  uint8 constant RETURN_PROVEN = 255;

  mapping(string => Race) races;

  function createRace(string calldata raceId, bytes32 startMarkerHash, string calldata startMarkerSecret) external payable;
  function addWaypoint(string calldata raceId, bytes32 waypointHash, string calldata waypointSecret) external;
  function startRace(string calldata raceId, string calldata raceSecret) external payable;

  function register(string memory raceId) public payable {
    // kiss for now
    require (msg.value == 1 ether, "Register with exactly 1 ether");
    if (keccak256(bytes(races[raceId].raceId)) == keccak256(bytes(raceId))) {
      require (races[raceId].racers[msg.sender] == 0, "Racer already registered");
        races[raceId].racers[msg.sender] = block.number;
    }
  }

  function prove(string memory raceId, string memory markerId, string memory guess) public returns (bool proven, uint8 cause){
    if (markerExists(raceId, markerId)) {
      if (keccak256(abi.encodePacked(guess)) == races[raceId].markerMap[markerId].markerHash){
        races[raceId].markerMap[markerId].foundByRacers[msg.sender] = block.number;
        return (true, RETURN_PROVEN);
      }
      return (false, RETURN_UNPROVEN);
    }
    return (false, RETURN_NOT_FOUND);
  }

  function completeRace(string calldata raceId) external;

  function keccak256helper(string calldata thing) external pure returns (bytes32){
        return keccak256(abi.encodePacked(thing));
  }

  function raceExists(string memory raceId) public view returns (bool) {
    return keccak256(bytes(races[raceId].raceId)) == keccak256(bytes(raceId));
  }

  function markerExists(string memory raceId, string memory markerId) public view returns (bool) {
    return raceExists(raceId) &&
      keccak256(bytes(races[raceId].markerMap[markerId].markerId)) == keccak256(bytes(markerId));
  }




}