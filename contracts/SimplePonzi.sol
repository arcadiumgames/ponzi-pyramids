pragma solidity ^0.5.0;

contract SimplePonzi {
  address public currentBacker;
  uint public currentContribution = 0;

  function () payable public {
    // new investments must be 10% higher than the current investment
    uint minimumContruibution = currentContribution * 11/10;
    require(msg.value > minimumContruibution);

    // document new backer
    address previousBacker = currentBacker;
    currentBacker = msg.sender;
    currentContribution = msg.value;

    // payout for previous backer
    previousBacker.send(msg.value);
  }
}
