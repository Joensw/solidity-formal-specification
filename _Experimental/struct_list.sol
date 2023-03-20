// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Lists {

    struct List {
        CustomStruct[] items;
    }

    struct CustomStruct {
        uint ID;
        string name;
        bool isEnabled;
        // further fields ...
    }

    function add(List storage self, CustomStruct memory cs) public {
        self.items.push(cs);
    }


    function size(List storage self) public view returns (uint ret) {
        ret = self.items.length;
    }


    function contains(List storage self, CustomStruct memory cs) public view returns (bool isContained) {
        for (uint i = 0; i < self.items.length; i++) {
            if (equals(self.items[i], cs)) {
                return true;
            }
        }
        return false;
    }


    function remove(List storage self, uint index) public {
        require(index < self.items.length);
        require(index >= 0);

        for (uint i = index; i < self.items.length - 1; i++) {
            self.items[i] = self.items[i + 1];
        }

        self.items.pop();
    }


    function removeObject(List storage self, CustomStruct memory cs) public returns (bool success, uint outIndex) { 
        bool found = false;
        uint index = 0;

        for (uint i = 0; i < self.items.length; i++) {
            if (equals(self.items[i], cs)) {
                found = true;
                index = i;
                break;
            }
        }

        if (found) {
            remove(self, index);
            return (true, index);
        }

        // what we return here as an index doesnt matter, as the first return value is false anyway
        return (false, index);
    }


    function indexOf(List storage self, CustomStruct memory cs) public view returns (bool valid, uint index){
        index = 0;

        for (uint i = 0; i < self.items.length; i++) {
            if (equals(self.items[i], cs)){
                index = i;
                return (true, index);
            }
        }
        return (false, index);
    }


    function isEmpty(List storage self) public view returns (bool out) {
        out = self.items.length == 0;
    }


    function get(List storage self, uint index) public view returns (CustomStruct memory ret) {
        require(index < self.items.length);
        require(index >= 0);

        ret = self.items[index];
    }

    function set(List storage self, uint index, CustomStruct memory cs) public {
        require(index < self.items.length);
        require(index >= 0);

        self.items[index] = cs;
    }

    function clear(List storage self) public {
        delete self.items;
    }

    function equals(CustomStruct storage cs_1, CustomStruct memory cs_2) private view returns (bool) {
        // adjust method according to desired functionality
        return cs_1.ID == cs_2.ID;
    }
    
}

contract ExampleUsage {

    using Lists for Lists.List;
    Lists.List private myList;

    // adjust equals and CustomStruct from the List library above to desired functionality ...

    function examples() public {
        Lists.CustomStruct memory myStruct_1 = Lists.CustomStruct(1, "Jeremy", true);
        myList.add(myStruct_1);

        // myList : {{1, "James", true}}

        Lists.CustomStruct memory myStruct_2 = Lists.CustomStruct(2, "Steven", false);
        myList.add(myStruct_2);

        // myList : {[1, "James", true], [1, "Steven", false]}  

        Lists.CustomStruct memory myStruct_3 = Lists.CustomStruct(3, "Charles", true);
        myList.set(0, myStruct_3);

        // myList : {[3, "Charles", true], [1, "Steven", false]}        
        
        uint index = myList.indexOf(cs)(myStuct_2);

        // index : 1

        myList.removeObject(myStruct_2);

        // myList : {[3, "Charles", true]}   

        myList.remove(0);     

        // myList : {}   
    }
}