pragma solidity >=0.5.16;

contract Election {
    // Model a Candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }
    event votedEvent (
        uint indexed _candidateId
    );

    event NominatedEvent (
        string indexed _name
    );

    // store votes accounts
    mapping(address => bool) public voters;

    // Read/write candidates
    mapping(uint => Candidate) public candidates;

    // Store Candidates Count
    uint public candidatesCount;

    // Remaining Nomination
    uint public availableNominations=4;


    //Maximum Nominations
    uint public maxNominations = 4;

    // store votes accounts
    mapping(address => bool) public Nominiee;
    

    constructor () public {
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
    }

    function addCandidate (string memory _name) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        availableNominations = maxNominations - candidatesCount;
    }


    function vote (uint _candidateId) public {


        require(!voters[msg.sender]);

        require(_candidateId > 0 && _candidateId <= candidatesCount);

        voters[msg.sender] = true;
        

        candidates[_candidateId].voteCount ++;

        // trigger voted event
        emit votedEvent( _candidateId);
        
    }

    function Nomination (string memory _name) public {

        require(availableNominations>0);


        require(!Nominiee[msg.sender]);

        Nominiee[msg.sender] = true;
        addCandidate(_name);

        // trigger voted event
        emit NominatedEvent( _name);
        
    }

    



}