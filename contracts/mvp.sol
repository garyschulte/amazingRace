pragma solidity >=0.4.21 <0.7.0;

import "./ERC165.sol";
import "./AmazingRace.sol";

contract mvp is AmazingRace, ERC165Mappable {

  uint8 constant RETURN_NOT_FOUND = 0;
  uint8 constant RETURN_FOUND = 1;
  uint8 constant RETURN_UNPROVEN = 101;
  uint8 constant RETURN_PROVEN = 255;

  uint8 constant STATE_INIT = 1;
  uint8 constant STATE_RUNNING = 15;
  uint8 constant STATE_COMPLETED = 127;
  uint8 constant STATE_CLOSED = 255;

  uint8 constant RACE_MARKER_NONE = 0;
  uint8 constant RACE_MARKER_ROOT = 1;

  //race mapping
  mapping(string => Race) races;

  function createRace(string calldata raceId, bytes32 startMarkerHash, string calldata startMarkerSecret) external payable {
    //TODO: add race owner logic, check for existing race by that name
    require (msg.value == 1 ether, "Start race with exactly 1 ether");
    RaceMarker memory startMarker = RaceMarker(RACE_MARKER_ROOT, RACE_MARKER_NONE, startMarkerHash, startMarkerSecret);
    Race memory newRace = Race(STATE_INIT, raceId);
    races[raceId] = newRace;
    races[raceId].markerMap[RACE_MARKER_ROOT] = startMarker;
  }

  function addWaypoint(string calldata raceId, bytes32 waypointHash, string calldata waypointSecret) external returns (bool, uint8) {
    //TODO: add race owner logic for authz
    if (markerExists(raceId, 1)) {
      if (races[raceId].raceState == STATE_INIT) {
        uint8 raceMarkerId = RACE_MARKER_ROOT;
        uint8 newRaceMarkerId = raceMarkerId + 1;
        // TODO: safe arithmetic here
        while(markerExists(raceId, newRaceMarkerId)) {
          raceMarkerId = raceMarkerId + 1;
          newRaceMarkerId = raceMarkerId + 1;
        }
        // TODO: safe arithmetic here
        races[raceId].markerMap[newRaceMarkerId] = RaceMarker(newRaceMarkerId, RACE_MARKER_NONE, waypointHash, waypointSecret);
        races[raceId].markerMap[raceMarkerId].nextMarkerId = newRaceMarkerId;
        return (true, STATE_INIT);
      }
      return (false, races[raceId].raceState);

    }
    return (false, RETURN_NOT_FOUND);
  }

  function startRace(string calldata raceId, string calldata raceSecret) external payable {
    //no-op, TODO: add race owner logic to set race to "started", payable logic
  }

  function register(string memory raceId) public payable {
    // kiss for now
    require (msg.value == 1 ether, "Register with exactly 1 ether");
    if (keccak256(bytes(races[raceId].raceId)) == keccak256(bytes(raceId))) {
      require (races[raceId].racers[msg.sender] == 0, "Racer already registered");
        races[raceId].racers[msg.sender] = block.number;
    }
  }

  function prove(string memory raceId, uint8 markerId, string memory guess) public returns (bool proven, uint8 cause) {
    if (markerExists(raceId, markerId)) {
      if (keccak256(abi.encodePacked(guess)) == races[raceId].markerMap[markerId].markerHash){
        races[raceId].markerMap[markerId].foundByRacers[msg.sender] = block.number;
        return (true, RETURN_PROVEN);
      }
      return (false, RETURN_UNPROVEN);
    }
    return (false, RETURN_NOT_FOUND);
  }

  function completeRace(string calldata raceId) external {
    //no-op for now. need more shape!
  }

  function keccak256helper(string calldata thing) external pure returns (bytes32){
    return keccak256(abi.encodePacked(thing));
  }

  function raceExists(string memory raceId) public view returns (bool) {
    return keccak256(bytes(races[raceId].raceId)) == keccak256(bytes(raceId));
  }

  function markerExists(string memory raceId, uint8 markerId) public view returns (bool) {
    return raceExists(raceId) && markerId > RACE_MARKER_NONE &&
      races[raceId].markerMap[markerId].markerId == markerId;
  }

  function isRaceStarted(string memory raceId) public view returns (bool) {
    return raceExists(raceId) && races[raceId].raceState > 0 && races[raceId].raceState < 255;
  }

}