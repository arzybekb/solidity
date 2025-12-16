// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StringCounter {
    mapping(string => uint) private counts;

    function setString(string calldata valString) public {
        counts[valString]+=1;
    }

   function getStringCount(string calldata value) public view returns (uint256) {
    return counts[value];
}
}


// contract Users {
//     struct User {
//         string name;
//         uint age;
//     }

//     mapping(address => User) public users;

//     function setUser(string calldata name, uint age) public {
//         users[msg.sender] = User(name, age);
//     }
// }