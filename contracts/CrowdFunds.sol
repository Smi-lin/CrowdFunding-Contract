// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string titleFunds;
        string desc;
        uint256 target;
        uint256 timeLimit;
        uint256 amountReceived;
        string image;
        bool withdrawan;
        address[] contributors;
        uint256[] contributions;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;

    function createCampaigner(
        address _owner,
        string memory _title,
        string memory _desc,
        uint256 _target,
        uint256 _limit,
        string memory _image
    ) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(
            campaign.timeLimit < block.timestamp,
            "The deadline should be a future time limit"
        );

        campaign.owner = _owner;
        campaign.titleFunds = _title;
        campaign.desc = _desc;
        campaign.target = _target;
        campaign.timeLimit = _limit;
        campaign.amountReceived = 0;
        campaign.image = _image;
        campaign.withdrawan = false;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    function donateCampaigner(uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.contributors.push(msg.sender);
        campaign.contributions.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountReceived = campaign.amountReceived + amount;
        }
    }

    function withdraw(uint256 _id) public {
        Campaign storage campaign = campaigns[_id];

        require(
            msg.sender == campaign.owner,
            "Only the campaign owner can withdraw ther funds."
        );
        require(!campaign.withdrawan, "Amount withdrawn already");
        require(
            block.timestamp >= campaign.timeLimit,
            "timelimit not reached yet."
        );
        require(
            campaign.amountReceived >= campaign.target,
            "Campaign target not met."
        );

        uint256 payoutAmount = campaign.amountReceived;
        campaign.amountReceived = 0;
        campaign.withdrawan = true;

        (bool sent, ) = payable(campaign.owner).call{value: payoutAmount}("");
        require(sent, "Unable to send funds to the campaign");
    }

    function getContributors(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].contributors, campaigns[_id].contributions);
    }

    function getCampaigners() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for (uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }

        return allCampaigns;
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
