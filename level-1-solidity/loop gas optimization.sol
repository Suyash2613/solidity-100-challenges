pragma solidity^0.8.16;
 contract storedata{

    struct User{
        address id;
        string name;
    }

  User[] public user;

  function storedata(Users[] calldata _users ) external {
    uint256 lenght = _users.lenght;
     for (uint256 i = 0; i < len; ) {
            users.push(User({
                id: _users[i].id,
                name: _users[i].name
            }));

            unchecked { i++; } // ✅ micro gas optimization
        }
    }
  }
 