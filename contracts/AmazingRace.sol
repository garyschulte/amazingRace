pragma solidity >=0.4.21 <0.7.0;

interface AmazingRace {

  struct RaceMarker {
    // identifier for this race marker
    uint8 markerId;
    // next waypoint/marker id; implementation must ensure this is acyclic and unique
    uint8 nextMarkerId;
    // keccak256 hash of the marker value at this location
    bytes32 markerHash;
    // encrypted hint/instructions for finding this waypont, decryptable via the marker value of the prior waypoint
    string markerSecret;
    // map players/racers => timestamp if/when they have found the marker
    mapping(address => uint) foundByRacers;
  }

  struct Race {
    // state of race, 1 -> unstarted, 15 -> running, 127 -> completed, 255 -> closed
    uint8 raceState;
    //race identifier id, and the implied RaceMarker start id
    string raceId;
    // map of all racers, address to registration time
    mapping(address => uint) racers;
    // map of all waypoints/markers
    mapping(uint8 => RaceMarker) markerMap;
  }

  /*
   * Create a race.  An initial deposit is required to start a race and seed the pot.
   * raceId - string id used to identify the race
   * startMarkerHash - bytes32 keccak256 hash of the marker value at the beginning of the race.
   * startMarkerSecret - string hash of the key necessary for the race owner to enable/start the race.
   *
   */
  function createRace(string calldata raceId, bytes32 startMarkerHash, string calldata startMarkerSecret) external payable;

  /*
   * Add a waypoint to the race.  The race is essentially a list of RaceMarker waypoints and this
   * function adds the waypoint to the tail of the list.
   * The waypoint hint/instructions are encrypted with the marker VALUE of the prior waypoint
   * as a key.  This implies off-chain encryption and coordination in the race app during race
   * construction.
   *
   * raceId - string id used to identify the race
   * waypointHash - bytes32 keccak256 hash of the waypoint value
   * waypointSecret - hint/instructions for finding this waypoint
   *
   */
  function addWaypoint(string calldata raceId, bytes32 waypointHash, string calldata waypointSecret) external returns (bool, uint8);

  /*
   * Begin the race represented by this raceId, if the correct secret is supplied.
   * raceId - string id used to identify the race
   * startMarker - race start marker secret value
   */
  function startRace(string calldata raceId, string calldata raceSecret) external payable;


  /*
   * Register to participate in this race.  Registration is payable, since the game's pot is self-funding.
   * string raceId - id of the race for which you wish to register.
   */
  function register(string calldata raceId) external payable;

  /*
   * Prove you have found the waypoint.  Returns boolean and a cause.
   * raceId - string id of the race
   * markerId - string id of the marker/waypoint
   * markerValue - the marker value satisfying marker hash
   */
  function prove(string calldata raceId, uint8 markerId, string calldata markerValue) external returns (bool proven, uint8 cause);

  /*
   * Once you have discovered all waypoints you may complete the race.
   * If you are the first race entrant to complete, you win the pot.
   *
   */
  function completeRace(string calldata raceId) external;

  /*
   * Check to see if this race has begun.
   */
  function isRaceRunning(string calldata raceId) view external returns (bool);

}
