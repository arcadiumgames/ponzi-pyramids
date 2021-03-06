pragma solidity ^0.5.0;

contract GradualPonzi {
  address[] public backers;
  mapping(address => uint) public balances;
  uint public constant MINIMUM_INVESTMENT = 1e15;

  constructor () public {
    backers.push(msg.sender);
  }

  function () external payable {
    require(msg.value >= MINIMUM_INVESTMENT);
    uint eachBackerGets = msg.value / backers.length;

    for (uint i = 0; i < backers.length; i++) {
      balances[backers[i]] += eachBackerGets;
    }
    backers.push(msg.sender);
  }

  function withdraw() public {
    uint payout = balances[msg.sender];
    balances[msg.sender] = 0;
    msg.sender.transfer(payout);
  }
}
