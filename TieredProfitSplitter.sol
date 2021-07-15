pragma solidity ^0.5.0;

// Splitting the profits between Associate-level employees, rudimentary percentages are calculate 
// for different tiers of employees (CEO, CTO, and Bob). 
// Bob (employee 3) gets 15% of the amount, CTO (employee 2) gets 25% of the amount and 
// the CEO (employee 1) gets 60% plus any remaining left after it has been divided.

// lvl 2: tiered split
contract TieredProfitSplitter {
    address payable employee_one; // ceo
    address payable employee_two; // cto
    address payable employee_three; // bob

    // address of the human resource 
    address human_resources;

    // The sender/user is the human resouce and is authorized
    modifier onlyHumanResource {
        require(msg.sender == human_resources, "you are not authorized to make transactions from this contract");
        _;
    }

    // value is more than 100, as anything less than 100, when integer divide by 100, will result in 0
    modifier throwIfLessThan100 {
        require(msg.value >= 100, "The value has to be greater than 100");
        _;
    }

    
    // Constructor to set the employee1, employee2 and employee3 addresses
    constructor(address payable _one, address payable _two, address payable _three) public {
        // Set the human resources as the sender
        human_resources = msg.sender;

        employee_one = _one;
        employee_two = _two;
        employee_three = _three;
    }

    // Should always return 0! Use this to test your `deposit` function's logic
    function balance() public view returns(uint) {
        return address(this).balance;
    }

    function deposit() public payable  onlyHumanResource throwIfLessThan100 {
        

        uint points = msg.value / 100; // Calculates rudimentary percentage by dividing msg.value into 100 units
        uint total;
        uint amount;

        // @TODO: Calculate and transfer the distribution percentage
        // Step 1: Set amount to equal `points` * the number of percentage points for this employee
        // Step 2: Add the `amount` to `total` to keep a running total
        // Step 3: Transfer the `amount` to the employee

        //employee_one gets 60% of the value, CEO
        amount = points * 60;
        total += amount;
        employee_one.transfer(amount);

        //employee_one gets 25% of the value, CTO
        amount = points * 25;
        total += amount;
        employee_two.transfer(amount);
        
        //employee_one gets 15% of the value
        amount = points * 15;
        total += amount;
        employee_three.transfer(amount);


        //Send the remainder to the employee with the highest percentage by subtracting `total` from `msg.value`, and sending that to an employee
        employee_one.transfer(msg.value - total); // ceo gets the remaining wei

    }

    function() external payable {
        deposit();
    }
}
