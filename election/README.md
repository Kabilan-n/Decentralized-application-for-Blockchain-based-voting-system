# Decentralized-application-for-Blockchain-based-voting-system

## Voting Dapp

Blockchain could be used to facilitate a modern voting system. Voting with blockchain carries the potential to eliminate election fraud and boost voter turnout. Using blockchain in this way would make votes nearly impossible to tamper with. The blockchain protocol would also maintain transparency in the electoral process, reducing the personnel needed to conduct an election and providing officials with nearly instant results. This would eliminate the need for recounts or any real concern that fraud might threaten the election.

In this project we have done a voting dapp using solidity language on Ethereum Virtual Machine. This dapp holds an election between two candidates. As this is built on top of Ethereum’s blockchain the voters need an account with a wallet address with some Ether. Once they connect to the network, they can cast their vote and pay a small transaction fee to write this transaction to the blockchain. This transaction fee is called “gas”. Whenever the vote is cast, some of the nodes on the network, called miners, compete to complete this transaction. The miner who completes this transaction is awarded the Ether that we paid to vote. Note that only writing something on blockchain costs transaction fees, just seeing the blocks in the blockchain does not require any gas fees as reading data from blockchain is free. This is how the voting process works on blockchain. The Ethereum blockchain allows us to execute code with the Ethereum Virtual Machine (EVM) on the blockchain with smart contracts. Smart contracts are in charge of reading and writing data to the blockchain, as well as executing business logic. Smart contacts are written in a programming language called Solidity. These smart contracts represent the agreement of taking the valid votes in count and the candidate with the most votes will win the election.

If we see the framework of dapp, it’s front-end client that is written in HTML, CSS, and Javascript. For decentralised applications the backend is taken from the Ethereum blockchain whereas for the centralized apps it is taken from servers. All the business logics for our dapps are coded in smart contracts.
These ethereum smart contracts can be deployed on our local Ethereum blockchain as well as on web3 using IPFS. 

### Setting up the environment

All the steps involved in this process are done on EVM. We need to install the dependencies like node.js, Truffle Framework. Truffle Framework, which allows us to build decentralized applications on the Ethereum blockchain. It provides a suite of tools that allow us to write smart contacts with the Solidity programming language. It also enables us to test our smart contracts and deploy them to the blockchain.
Then we need Ganache which is a local in-memory blockchain. It will give us 10 external accounts with addresses on our local Ethereum blockchain. Each account is preloaded with 100 fake ether. We can use these fake ethers for our transactions i.e casting votes. Each account has a unique address and a private key. Each account address will serve as a unique identifier for each voter in our election.
Another dependency is Metamask. Metamask is a chrome extension that helps us to connect to our local Ethereum blockchain with our personal account, and interact with our smart contract. 
To start with dapp, instead of starting from scratch we can use some of the predefined skeletons in the truffle box then on top of that we can create our voting dapp. 
The framework looks like this

		build/contracts
		  | Election.json
		  | Migration.json
		contracts
		  | Election.sol
		  | Migration.sol
		migrations
		  | 1_initial_migration.js
		  | 2_deploy_contracts.js
		node_modules
		src
		  | css
		  | fonts
		  | images
		  | js
			  | app.js
			  | truffle-contract.js
		  | index.html
		test
		  | election.js
		truffle.js

contracts dir: this directory contains all the smart contracts. 
migrations dir: this directory contains all of the migration files. When a smart contract is deployed to the blockchain, theblockchain's state is updated, and therefore needs a migration.
node_modules dir: this directory contains all the dependencies. 
src directory: in this directory the client-side application or the front-end is defined.
test directory: t this directory contains all the test files for our smart contracts.
truffle.js file: this is the main configuration file for the Truffle project.

### Smart contract for Voting dapp

Before starting with our contract we need to specify the version of solidity this contract is using by declaring the solidity version with the pragma solidity statement. Like class here the smart contracts start with a contract keyword. As multiple candidates contest in the election we need to store multiple attributes about each candidate like candidate's id, name, and vote count. This can be created using Solidity Struct, allowing us to create our own structure types. 

	pragma solidity >=0.5.16;

	contract Election {
	    // Model a Candidate
	    struct Candidate {
		uint id;
		string name;
		uint voteCount;
	    }

To store this structure type  Solidity mapping Is used. A mapping in Solidity is like an associative array or a hash, that associates key-value pairs. The key to the mapping is an unsigned integer, and the value is a Candidate structure type. To keep track of the accounts that are already voted we define a voters mapping 
As of now we have implemented only the voting process. This can be further taken by adding steps like nominating result announcements. For this there needs an event trigger for each of this process. Here we have added a votedEvent event that updates our client-side application when an account has voted.


	    // Read/write candidates
	    mapping(uint => Candidate) public candidates;

	   // store voted accounts
	   mapping(address => bool) public voters;

	   event votedEvent (
	       uint indexed _candidateId
	   );

	    // Store Candidates Count
	    uint public candidatesCount;

In solidity we can't  get the size of mapping, so for tracking the number of candidates contesting in an election we use an unsigned integer as a candidate cache, this gets updated every time a candidate is added. 


	   function addCandidate (string memory _name) private {
		candidatesCount ++;
		candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
	    }
	   constructor () public {
	       addCandidate("Candidate 1");
	       addCandidate("Candidate 2");
	   }   function addCandidate (string memory _name) private {
		candidatesCount ++;
		candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
	    }
	   constructor () public {
	       addCandidate("Candidate 1");
	       addCandidate("Candidate 2");
	   }


The function addCandidate is used to add a candidate to the mapping. This function takes the candidate's name as an argument. Each and every time this function is called, the candidate cache will be incremented so that a new candidate is added to the mapping. Then we update the mapping with a new Candidate struct, using the current candidate count as the key. This Candidate struct is initialized with the candidate id from the current candidate count, the name from the function argument, and the initial vote count to 0. Visibility of this function is kept private as it can be called only within this contract. 
The candidates are added by calling this function within the constructor.

    function vote (uint _candidateId) public {


        require(!voters[msg.sender]);

        require(_candidateId > 0 && _candidateId <= candidatesCount);

        voters[msg.sender] = true;
        

        candidates[_candidateId].voteCount ++;

        // trigger voted event
        emit votedEvent( _candidateId);
        
    }
    

We create a vote function for implementing voting. The core functionality of this function is to increase the candidate's vote count by reading the Candidate struct out of the "candidates" mapping and increasing the "voteCount" by 1 with the increment operator (++). 
It implements require statements that will stop execution if the conditions are not met. First require that the voter hasn't voted before. We do this by reading the account address with "msg.sender" from the voters mapping. Next, it verifies the candidate id, The candidate id must be greater than zero and less than or equal to the total candidate count.

### Testing the Smart Contracts

Once a data is written or a transaction happens on a blockchain it can not be reversed, blockchains are irreversible and immutable. So before publishing the contracts on the blockchain we need to test them with test scripts. 

	var Election = artifacts.require("./Election.sol");

	contract("Election",function(accounts) {
	    var electionInstance;

	    it("Initializes with two candidates", function(){
		return Election.deployed().then(function(instance){
		    return instance.candidatesCount();
		}).then(function(count){
		    assert.equal(count,2);
		});
	    });
     

This test checks that the contract was initialized with the correct number of candidates by checking the candidates count is equal to 2.

    it("It initializes the candidates with the correct values", function(){
        return Election.deployed().then(function(instance){
            electionInstance = instance;
            return electionInstance.candidates(1);
        }).then(function(candidates){
            assert.equal(candidates[0],1,"contains correct id");
            assert.equal(candidates[1],"Candidate 1","contains correct name");
            assert.equal(candidates[2],0,"contains correct votes");
            return electionInstance.candidates(2);
        }).then(function(candidates){
            assert.equal(candidates[0],2,"contains correct id");
            assert.equal(candidates[1],"Candidate 2","contains correct name");
            assert.equal(candidates[2],0,"contains correct votes");
            
        });
    });
    
  
This test inspects the values of each candidate in the election, ensuring that each candidate has the correct id, name, and vote count. 

    it("allows a voter to cast a vote", function() {
        return Election.deployed().then(function(instance) {
          electionInstance = instance;
          candidateId = 1;
          return electionInstance.vote(candidateId, { from: accounts[0] });
        }).then(function(receipt) {
          return electionInstance.voters(accounts[0]);
        }).then(function(voted) {
          assert(voted, "the voter was marked as voted");
          return electionInstance.candidates(candidateId);
        }).then(function(candidate) {
          var voteCount = candidate[2];
          assert.equal(voteCount, 1, "increments the candidate's vote count");
        })
    });
    
This test inspects that the function increments the vote count for the candidate and that the voter is added to the mapping whenever they vote. 

          return electionInstance.vote(99, { from: accounts[1] })
        }).then(assert.fail).catch(function(error) {
          assert(error.message.indexOf('revert') >= 0, "error message must contain revert");
          return electionInstance.candidates(1);
        }).then(function(candidate1) {
          var voteCount = candidate1[2];
          assert.equal(voteCount, 1, "candidate 1 did not receive any votes");
          return electionInstance.candidates(2);
        }).then(function(candidate2) {
          var voteCount = candidate2[2];
          assert.equal(voteCount, 0, "candidate 2 did not receive any votes");
        });
      });
      
We can also assert that the transaction failed and that an error message is returned,  ensuring that the error message contains the "revert" substring. Then we can ensure that our contract's state was unaltered by ensuring that the candidates did not receive any votes.

    it("throws an exception for double voting", function() {
        return Election.deployed().then(function(instance) {
          electionInstance = instance;
          candidateId = 2;
          electionInstance.vote(candidateId, { from: accounts[1] });
          return electionInstance.candidates(candidateId);
        }).then(function(candidate) {
          var voteCount = candidate[2];
          assert.equal(voteCount, 1, "accepts first vote");
          // Try to vote again
          return electionInstance.vote(candidateId, { from: accounts[1] });
        }).then(assert.fail).catch(function(error) { 
          assert(error.message, "error message must contain revert");
          return electionInstance.candidates(1);
        }).then(function(candidate1) {
          var voteCount = candidate1[2];
          assert.equal(voteCount, 1, "candidate 1 did not receive any votes");
          return electionInstance.candidates(2);
        }).then(function(candidate2) {
          var voteCount = candidate2[2];
          assert.equal(voteCount, 1, "candidate 2 did not receive any votes");
        });
    });  

In this test, we’ll try to vote with the account which hasn't voted before. Then we'll cast a vote with that account. Then we'll try to vote again. We'll assert that an error has occurred here. We can inspect the error message, and ensure that no candidates received votes, just like the previous test. 

Image
When our smart contracts passes all the test it’s ready to deploy along with front end created using HTML, CSS and Js
This project can be further extended by adding some events like nomination and result announcement and we can also give a certain period for each event once the time is up the events automatically switch to the next event. 
This is how the front-end application for the client side will appear

![EL](https://user-images.githubusercontent.com/60337704/147131794-7fec723b-2bce-4255-9264-db84de5d4fcb.png)

When a voter casts a vote he needs to pay some gas in ethers. 

![mm](https://user-images.githubusercontent.com/60337704/147131817-827f3caa-0af4-4772-b803-54e858d30ace.png)
