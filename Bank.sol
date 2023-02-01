pragma solidity 0.7.5; 

contract Bank {

    mapping(address => uint) balance; 
    address owner;

    event depositDone(uint amount, address indexed addedTo);
    event transferDone(address indexed recipient, uint amount, address indexed sender);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier costs(uint price) {
        require(msg.value >= price);
        _;
    }



    constructor(){
        owner = msg.sender;
    }

    function deposit() public payable returns (uint){
        balance[msg.sender] += msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }
    
    function withDraw(uint amount) public returns (uint){
        //check balance of msg.sender is sufficient.
        require(balance[msg.sender] >= amount, 
        "Insufficient Funds: Please enter withdrawal amount less or equal to your current balance"
        );
        msg.sender.transfer(amount);
        
        //ajust balance;
        balance[msg.sender] -= amount;
        return balance[msg.sender];
    }

    function getBalance() public view returns (uint){
        return balance[msg.sender];
    }


    function transfer(address recipient, uint amount) public  {
        require(balance[msg.sender] >= amount, 
        "Balance not sufficient."
        );
        require(msg.sender != recipient, 
        "Don't send money to yourself."
        );

        uint previousSenderBalance = balance[msg.sender];

        _transfer(msg.sender, recipient, amount);
        emit transferDone(recipient, amount, msg.sender);

        assert(balance[msg.sender] == previousSenderBalance - amount);

        //event logs and further checks
    }

    function _transfer(address from, address to, uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;
    }

}