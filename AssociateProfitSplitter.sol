pragma solidity ^0.5.0;

//This contract accepts Ether into the contract and divide the Ether evenly among 3 associate level employees. 
// This will allow the Human Resources department to pay employees quickly and efficiently.
// lvl 1: equal split
contract AssociateProfitSplitter {
    // Create three payable addresses representing `employee_one`, `employee_two` and `employee_three`.
    address payable employee_one;
    address payable employee_two;
    address payable employee_three;
    
    // address of the human resource 
    address human_resources;
    
    // modifier to check if the sender is human resources 
    modifier onlyHumanResource {
        require(msg.sender == human_resources, "you are not authorized to make transactions from this contract");
        _;
    }

    // Constructor to set the employee1, employee2 and employee3 addresses
    constructor(address payable _one, address payable _two, address payable _three) public {
        // Set the human resources as the sender
        human_resources = msg.sender;
        // Set the address for the three employees
        employee_one = _one;
        employee_two = _two;
        employee_three = _three;
    }

    // Getter function to return the balance of the smart contract
    function balance() public view returns(uint) {
        // return the balance, balance should always be 0, as no ether is stored in the contract
        return address(this).balance;
    }

    // Devide and depoist the amount equally among 3 employees , only human resource has the privilege
    // Any reminder/left over after dividing into 3 equal parts is sent back to the sender
    function deposit() public payable onlyHumanResource {

        //  Split `msg.value` into three
        uint amount = msg.value; 
        amount = amount / 3;

        // Transfer the amount to each employee
        employee_one.transfer(amount);
        employee_two.transfer(amount);
        employee_three.transfer(amount);

        // sending the remainder  back to HR (`msg.sender`)
        msg.sender.transfer(msg.value - amount * 3);

    }
    
    // fallback function to recieve ether
    function() external payable {
        //Enforce that the `deposit` function is called in the fallback function!
        deposit();
    }
}
