pragma solidity ^0.5.0;

/*
This contract will manage an employee's "deferred equity incentive plan" in which 1000 shares will be distributed over 4 years
to the employee. It does not work with Ether but with  amounts stored and set that represent the number of distributed shares 
the employee owns and enforcing the vetting periods automatically.
*/
// lvl 3: equity plan
contract DeferredEquityPlan {
    
    // address of the human resource 
    address human_resources;

    // Create payable addresses representing `employee`
    address payable employee; 
    
    // this employee is active at the start of the contract
    bool active = true; 

    
    // Set the total shares and annual distribution
    uint16 total_shares = 1000;
    uint8 annual_distribution = 250;
    
    // permanently store the time this contract was initialized
    uint start_time = now; 

    // Set the `unlock_time` to be 365 days from now
    uint unlock_time =  start_time + 365 days;   
    
    // starts at 0
    uint16 public distributed_shares; 

    
    // Constructor to set the employee
    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }

    modifier hrOREmployee()  {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        _;
    }
    
    // calculate the distribute shares, if vested (fully owned by the employee) according to the schedule
    // annual_distribution (250) shares are vested annually, so in after the 1st year, annual_distribution shares are distributed, similarly for each year
    // for a max of total_shares shares. If a user tries to vest shares after 5+ years, the max shares will still be total_shares.
    function distribute() public hrOREmployee {
        
        
        require(active == true, "Contract not active.");
        // Add "require" statements to enforce that:
        // 1: `unlock_time` is less than or equal to `now`
        // 2: `distributed_shares` is less than the `total_shares`
        require(unlock_time <= now, "Shares can not be distributed at this time, please wait for Shares to vest");
        require(distributed_shares <= total_shares, "No Shares left to be distributed");
        

        // Add 365 days to the `unlock_time`
        unlock_time += 365 days;

        // Calculate the shares distributed by using the function (now - start_time) / 365 days * the annual distribution
        distributed_shares = uint16((now - start_time) / 365 days * annual_distribution);

        // double check in case the employee does not cash out until after 5+ years
        if (distributed_shares > total_shares) {
            distributed_shares = total_shares;
        }
    }

    // human_resources and the employee can deactivate this contract at-will
    function deactivate() public hrOREmployee {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }

    // Since we do not need to handle Ether in this contract, revert any Ether sent to the contract directly
    function() external payable {
        revert("Do not send Ether to this contract!");
    }

   
    
}
