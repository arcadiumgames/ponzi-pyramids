pragma solidity ^0.5.0;

contract SimplePyramid {
  uint public constant MINIMUM_INVESTMENT = 1e15; // 0.001 ether
  uint public numBackers = 0;
  uint public depth = 0;
  address[] public backers;
  mapping(address => uint) public balances;

  function SimplePyramid() public payable {
    require(msg.value >= MINIMUM_INVESTMENT);
    backers.length = 3;
    backers[0] = msg.sender;
    numBackers = 1;
    depth = 1;
    balances[address(this)] = msg.value;
  }

  function () payable public {
    require(msg.value >= MINIMUM_INVESTMENT);
    balances[address(this)] += msg.value;

    numBackers += 1;
    backers[numBackers - 1] = msg.sender;

    if(numBackers == backers.length) {
      // pay out previous layer
      uint endIndex = numBackers - 2*depth;
      uint startIndex = endIndex - 2**depth(-1);
      for (uint = startIndex; i < endIndex; i++)
      balances[backers[i]] += MINIMUM_INVESTMENT;

      // spread remaining ether among all participants
      uint paid = MINIMUM_INVESTMENT * 2**(depth-1);
      uint eachBackerGets = (balances[address(this)] - paid) / numBackers;

      for (i = 0; i < numBackers; i++) {
        balances[backers[i]] += eachBackerGets;
      }

      // update state variables
      balances[address(this)] = 0;
      depth += 1;
      backers.length += 2**depth;
    }
  }

  function withdraw() public {
    uint payout = balances[msg.sender];
    balances[msg.sender] = 0;
    msg.sender.transfer(payout);
  }
}
