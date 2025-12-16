// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

contract RestaurantRating{
    address public owner;
    constructor(){
        owner=msg.sender;
    }
     struct Restaurant {
        uint256 rating;
        uint256 ratingCount;
        bool exist;
    }

    mapping(string => Restaurant) public restaurants;
    
    function addRestaurant(string memory restaurantName)public  {
        require(msg.sender == owner, "Only owner");
        require(restaurants[restaurantName].exist == true,"Restaurant already exist");
        restaurants[restaurantName] = Restaurant(0,0,true);
}}