contract WorldWideDB {

    struct KeyValue {
        address owner;
        string JSON; //the stored value, preferably represented in JSON format
        uint256 createdOn;

        uint256 deposit;

        int upvotes;
        int downvotes;
        uint256 tips;
    }

    mapping (string => KeyValue) DB;

    function Create(string key, string JSON) {
        KeyValue val = DB[key];

        if (val.owner = 0x00) {
            val = new KeyValue();

            val.owner = msg.sender;
            val.JSON = JSON;
            val.deposit = msg.value;
            val.createdOn = now;

            DB[key] = val;
        }
    }

    function Retrieve(string key) constant returns (string) {
        return DB[key].JSON;
    }

    function ReturnKeyValue(string key) constant returns (KeyValue) {
        return DB[key];
    }

    function Update(string key, string JSON) {
        KeyValue val = DB[key];

        if (val.owner != 0x00 && val.owner = msg.sender){
            val.JSON = JSON;
            DB[key] = val;
        }
    }

    function Delete(string key) {
        KeyValue val = DB[key];

        if (val.owner != 0x00 && val.owner = msg.sender){
            uint256 deposit = val.deposit;
            DB[key] = null;
            msg.sender.send(deposit);
        }
    }

    //a simple way to keep squatters away
    function Contest(string key, string JSON) {
        KeyValue val = DB[key];
        
        if (msg.value > (val.deposit * 11)/10 && (now - val.createdOn > 14 days)) 
        {
            address originalOwner = val.owner;
            uint256 originalDeposit = val.deposit;
            uint256 newDeposit = (msg.value + originalDeposit) / 2;

            val.owner = msg.sender;
            val.JSON = JSON;
            val.deposit = newDeposit;
            val.createdOn = now; //reopens the challange period for another 2 weeks

            DB[key] = val;

            originalOwner.send(newDeposit); //compensate the original claimer for their time by giving them at least 50% on top of their current deposit 
        }
    }

    //retrieve your deposit at any time
    function FetchDeposit(string key) {
        KeyValue val = DB[key];

        if (val.owner != 0x00 && val.owner = msg.sender) {
            uint256 money = val.deposit;
            val.deposit = 0;
            DB[key] = val;
            
            val.owner.send(money); 
        }
    }

    //WARNING: Transfers the deposit used to secure the key along with it!
    function Transfer(string key, address newOwner) {
        KeyValue val = DB[key];

        if (val.owner != 0x00 && val.owner = msg.sender){
            val.owner = newOwner;
            DB[key] = val;
        }
    }

    function Upvote(string key) {
        KeyValue val = DB[key];

        if (val.owner != 0x00) {
            val.upvotes++;
            DB[key] = val;
        }
    }

    function Downvote(string key) {
        KeyValue val = DB[key];

        if (val.owner != 0x00) {
            val.downvotes--;
            DB[key] = val;
        }
    }

    function Tip(string key) {
        KeyValue val = DB[key];

        if (val.owner != 0x00) {
            val.tips += msg.value;
            val.upvotes++;
            DB[key] = val;
        }
    }

    function FetchTip(string key) {
        KeyValue val = DB[key];

        if (val.owner != 0x00 && val.owner = msg.sender) {
            uint256 money = val.tips;
            val.tips = 0;
            DB[key] = val;
            
            val.owner.send(money); 
        }
    }
}
