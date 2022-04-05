// SPDX-License-Identifier: MIT
contract multisig_wallet{
    event Deposit(address indexed sender,uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner,uint indexed txId);
    event Revoke(address indexed owner,uint indexed txId);
    event Execute(uint indexed txId);


    modifier onlyOwner(){
        require(isOwner[msg.sender],"not owner");
        _;
    }

    modifier txExists(uint _txId){
        require(_txId<transactions.length,"transaction ID does not exist");
        _;
    }

    modifier notApproved(uint _txId){
        require(!approved[_txId][msg.sender],"transaction already approved");
        _;
    }

    modifier notExecuted(uint _txId){
        require(!transactions[_txId].executed,"transaction already executed");
        _;
    }


    struct Transaction{
        address to;
        uint value;
        bytes data;
        bool executed;
    }
    address[] public owners;
    mapping(address=>bool) public isOwner;
    uint public required;


    Transaction[] public transactions;
    mapping(uint=>mapping(address=>bool)) public approved;

    constructor(address[] memory _owners,uint _required){
        require(_owners.length>0,"owners required");
        require(_required>0&&_required<=owners.length,"Invalid required number of owners");
        for(uint i;i<_owners.length;i++){
            address owner=_owners[i];
            require(owner!=address(0),"invalid owner");
            require(!isOwner[owner],"Owner not unique");

            isOwner[owner]=true;
            owners.push(owner);

            required=_required;
        }

        
    }

    receive() external payable{
        emit Deposit(msg.sender,msg.value);
    
    }

    function submit(address _to,uint _value,bytes calldata _data) external onlyOwner{
        transactions.push(Transaction({
            to:_to,
            value:_value,
            data:_data,
            executed:false
        }));

        emit Submit(transactions.length-1);
    }


    function approve(uint _txId)external onlyOwner txExists(_txId) notApproved(_txId) notExecuted(_txId){
        approved[_txId][msg.sender]==true;
        emit Approve(msg.sender,_txId);

    }


    function _getApprovalCount(uint _txId) private view returns(uint count){

        for(uint i;i<owners.length;i++){
            if(approved[_txId][owners[i]]){
                count++;
            }
        }

    }

    function execute(uint _txId) external txExists(_txId) notExecuted(_txId){
        require(_getApprovalCount(_txId)>=required,"approvals<required");
        Transaction storage transaction=transactions[_txId];

        transaction.executed=true;
        

        (bool success, )=transaction.to.call{value:transaction.value}(transaction.data);
        emit Execute(_txId);



    }



}
