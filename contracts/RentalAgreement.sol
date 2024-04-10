// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract RentalAgreement {
    address public owner;
    address public tenant;
    uint256 public rentAmount;
    uint256 public depositAmount;
    uint256 public startDate;
    uint256 public endDate;
    bool public isActive;
    bool public isTerminated;

    event AgreementCreated(address indexed owner, address indexed tenant, uint256 rentAmount, uint256 depositAmount, uint256 startDate, uint256 endDate);
    event RentPaid(address indexed payer, uint256 amount);
    event DepositPaid(address indexed payer, uint256 amount);
    event AgreementTerminated(address indexed terminator);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyTenant() {
        require(msg.sender == tenant, "Only tenant can call this function");
        _;
    }

    modifier isActiveAgreement() {
        require(isActive && !isTerminated, "Agreement is not active or terminated");
        _;
    }

    constructor(address _owner, address _tenant, uint256 _rentAmount, uint256 _depositAmount, uint256 _startDate, uint256 _endDate) {
        owner = _owner;
        tenant = _tenant;
        rentAmount = _rentAmount;
        depositAmount = _depositAmount;
        startDate = _startDate;
        endDate = _endDate;
        isActive = true;
        isTerminated = false;

        emit AgreementCreated(owner, tenant, rentAmount, depositAmount, startDate, endDate);
    }

    function payRent() external payable onlyTenant isActiveAgreement {
        require(msg.value == rentAmount, "Incorrect rent amount sent");
        emit RentPaid(msg.sender, msg.value);
    }

    function payDeposit() external payable onlyTenant isActiveAgreement {
        require(msg.value == depositAmount, "Incorrect deposit amount sent");
        emit DepositPaid(msg.sender, msg.value);
    }

    function terminateAgreement() external onlyOwner isActiveAgreement {
        isTerminated = true;
        isActive = false;
        emit AgreementTerminated(msg.sender);
    }

    function withdrawDeposit() external onlyOwner {
        require(isTerminated, "Cannot withdraw deposit until agreement is terminated");
        payable(owner).transfer(depositAmount);
    }

    function withdrawRent() external onlyOwner {
        require(block.timestamp >= endDate, "Cannot withdraw rent until end date");
        payable(owner).transfer(rentAmount);
    }

    receive() external payable {
        // Allow contract to receive ETH
    }
}
