// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Goal-Based Fundraiser for Animal Shelter Expansion
contract AnimalShelterFundraiser {
    
    // The owner of the contract (who deployed it)
    address public owner;

    // The charity address where funds will be sent when goal is reached
    address public charity;

    // Fundraiser info
    string public fundraiserName;
    string public description;

    // Goal and tracking
    uint public goal = 100 ether;  // Target amount to raise
    uint public totalRaised;       // Total amount raised so far
    bool public fundsReleased = false;  // Has the money been sent to the charity yet?

    // Structure to hold each donation
    struct Donation {
        address donor;
        uint amount;
        string message;
        uint timestamp;
    }

    // Dynamic list of all donations
    Donation[] public donations;

    /// Constructor runs once at deployment
    /// @param _charity Address where funds will be sent after reaching goal
    /// @param _name Fundraiser name
    /// @param _desc Fundraiser description
    constructor(address _charity, string memory _name, string memory _desc) {
        owner = msg.sender;
        charity = _charity;
        fundraiserName = _name;
        description = _desc;
    }

    /// Public function to donate to the cause
    /// Automatically releases funds if goal is reached
    function donate() public payable {
        require(!fundsReleased, "Fundraiser already completed");
        require(msg.value > 0, "Donation must be greater than 0");

        // Record the donation
        donations.push(Donation({
            donor: msg.sender,
            amount: msg.value,
            message: "Thank you for your generous donation",
            timestamp: block.timestamp
        }));

        // Update total raised
        totalRaised += msg.value;

        // Check if goal is met
        if (totalRaised >= goal) {
            releaseFunds();
        }
    }

    /// Internal function to release all funds to the charity
    function releaseFunds() internal {
        require(!fundsReleased, "Funds already released");
        fundsReleased = true;
        payable(charity).transfer(address(this).balance);
    }

    /// View the donation list
    function getDonations() public view returns (Donation[] memory) {
        return donations;
    }

    /// Check fundraiser progress
    function getProgress() public view returns (uint raised, uint target) {
        return (totalRaised, goal);
    }

    /// View how many donations there are
    function getDonationCount() public view returns (uint) {
        return donations.length;
    }
}