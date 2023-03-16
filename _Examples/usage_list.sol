// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "../Lists/uint_list.sol";

contract ExampleUsage {

    using Lists for Lists.List;

    Lists.List private orders;

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function enqueue(uint orderNumber) public {
        orders.add(orderNumber);
    }

    function dequeue() public onlyOwner returns (uint orderNumber) {
        require(!orders.isEmpty(), "Queue is empty");
        orderNumber = orders.remove(0);
        return orderNumber;
    }

    function peek() public onlyOwner view returns (uint orderNumber) {
        require(!orders.isEmpty(), "Queue is empty");
        return orders.get(0);
    }

    function getOrderAtIndex(uint index) public onlyOwner view returns (uint orderNumber) {
        require(index < orders.size(), "Index out of bounds");
        return orders.get(index);
    }

    function updateOrder(uint index, uint newOrderNumber) public onlyOwner {
        require(index < orders.size(), "Index out of bounds");
        orders.set(index, newOrderNumber);
    }


}