// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Voting {
    uint256 public totalVotes;
    uint256 public voteFee;
    address public coordinator;
    uint8 public participantCount;
    uint8 public constant maxVotes = 50;
    uint8 public constant maxParticipants = 5;
    bool public registrationClosed;
    uint256 public votingDeadline;
    bool public winnerDeclared;

    enum Status { REGISTERED, UNREGISTERED }

    struct Participant {
        string name;
        address owner;
        uint256 voteCount;
        Status status;
    }

    error NotPaid();
    error AlreadyVoted();
    error NotRegistered();
    error RegistrationOpen();
    error VotingNotStarted();
    error VotingEnded();
    error VoteLimitReached();
    error WinnerAlreadyDeclared();

    mapping(uint8 => Participant) public participants;
    mapping(address => bool) public hasPaid;
    mapping(address => uint8) public voterVotes;

    constructor(uint256 _voteFee, address _coordinator) {
        voteFee = _voteFee;
        coordinator = _coordinator;
    }

    function makePayment() external payable {
        require(msg.value == voteFee, "Incorrect vote fee");
        hasPaid[msg.sender] = true;
        payable(coordinator).transfer(msg.value);
    }

    function registerParticipant(string calldata _name) external {
        require(!registrationClosed, "Registration is closed");
        require(participantCount < maxParticipants, "Max participants reached");

        participants[participantCount] = Participant({
            name: _name,
            owner: msg.sender,
            voteCount: 0,
            status: Status.REGISTERED
        });

        participantCount++;

        if (participantCount == maxParticipants) {
            registrationClosed = true;
            votingDeadline = block.timestamp + 5 minutes; 
        }
    }

    function vote(uint8 _participantId) external {
        if (!registrationClosed) revert VotingNotStarted();
        if (block.timestamp > votingDeadline) revert VotingEnded();
        if (!hasPaid[msg.sender]) revert NotPaid();
        if (voterVotes[msg.sender] > 0) revert AlreadyVoted();
        if (_participantId >= participantCount) revert NotRegistered();
        if (totalVotes >= maxVotes) revert VoteLimitReached();

        participants[_participantId].voteCount++;
        voterVotes[msg.sender]++;
        totalVotes++;
    }

    function declareWinner() external view returns (string memory winnerName, address winnerAddress, uint voteCount) {
        require(registrationClosed, "Voting not started");
        require(block.timestamp > votingDeadline, "Voting still active");
        require(!winnerDeclared, "Winner already declared");

        uint highestVotes = 0;
        uint8 winningId;

        for (uint8 i = 0; i < participantCount; i++) {
            if (participants[i].voteCount > highestVotes) {
                highestVotes = participants[i].voteCount;
                winningId = i;
            }
        }

        Participant memory winner = participants[winningId];
        return (winner.name, winner.owner, winner.voteCount);
    }

    function getParticipant(uint8 _id) external view returns (string memory, address, uint256, Status) {
        Participant memory p = participants[_id];
        return (p.name, p.owner, p.voteCount, p.status);
    }
}
