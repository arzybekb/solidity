// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

contract RestaurantRating {
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    struct Restaurant {
        uint256 rating;
        uint256 ratingCount;
        bool exist;
    }

    mapping(string => Restaurant) public restaurants;

    mapping(address => mapping(string => bool)) public hasUserRated;
    
    function addRestaurant(string memory restaurantName) public  {
        require(msg.sender == owner, "Only owner");
        require(!restaurants[restaurantName].exist,"Restaurant already exist");
        restaurants[restaurantName] = Restaurant(0,0,true);
    }

    function rateRestaurant(string memory restaurantName,uint rating) public {
        require(restaurants[restaurantName].exist, 'Restaurant not found');
        require(rating >= 1 && rating <= 5, "Rating must be 1-5");
        // require(restaurants[restaurantName].rating != 0, 'Already rated');
        require(!hasUserRated[msg.sender][restaurantName], "Already rated");

        restaurants[restaurantName].rating += rating;
        restaurants[restaurantName].ratingCount += 1;
        hasUserRated[msg.sender][restaurantName] = true;
    }

    function getAvarageRating (string memory restaurantName) public view returns (uint256) {
        Restaurant memory restaurant = restaurants[restaurantName];
        if (restaurant.ratingCount == 0) return 0;
        return restaurant.rating  / restaurant.ratingCount;
    }
}