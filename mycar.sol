pragma solidity ^0.6.0;

contract mycar {

    struct car {
        string manufacturer;
        string model;
        uint year_made;
        string chassis_number;
    }

    uint256 nextCar;
    mapping(uint=>car) car_registry;
    mapping(address => uint256[]) collections;
    mapping(uint256 => address) owners;
    mapping(uint256 => uint256) ownedPosition;

    function addCar(
        string memory _manufacturer,
        string memory _model,
        uint _year_made,
        string memory _chassis_number) internal returns (uint) {

        car_registry[nextCar] = car( {
            manufacturer : _manufacturer,
            model : _model,
            year_made : _year_made,
            chassis_number : _chassis_number
        });
        nextCar++;
        return nextCar-1;
    }
    
    function assignCar(uint256 index, address newOwner)internal{
        require(owners[index] == address(0), "this car already has an owner");
        owners[index] = newOwner;
        collections[newOwner].push(index);
        ownedPosition[index] = collections[newOwner].length - 1;
    }
   
    function addCarToRegistry(
        string memory _manufacturer,
        string memory _model,
        uint   _year_made,
        string memory _chassis_number,
        address newOwner
        ) public {
        uint pos = addCar(_manufacturer,_model,_year_made,_chassis_number);
        assignCar(pos,newOwner);
    }
    
    function getManufacturer(uint256 index) public view returns (string memory) {
        return car_registry[index].manufacturer;
    }
    
    function getModel(uint256 index) public view returns (string memory) {
        return car_registry[index].model;
    }
    
    function getChassis(uint256 index) public view returns (string memory) {
        return car_registry[index].chassis_number;
    }

    function getYear(uint256 index) public view returns (uint256) {
        return car_registry[index].year_made;
    }
    
    function getOwner(uint256 index) public view returns(address) {
        return owners[index];
    }
    
    function howManyCarsDoTheyOwn(address them) public view returns (uint256) {
        return collections[them].length;
    }
    
    function getCarByOwnerAndIndex(address them, uint256 index) public view returns (uint256) {
        return collections[them][index];
    }
    
    function transfer(uint256 index, address newOwner) public returns (bool) {
        require(getOwner(index)==msg.sender, "you cannot transfer that which you do not own");
        owners[index] = newOwner;
        uint256 pos = ownedPosition[index];
        uint len = collections[msg.sender].length - 1;
        collections[msg.sender][pos] = collections[msg.sender][len];
        collections[msg.sender].pop();
        
        collections[newOwner].push(index);
        ownedPosition[index] = collections[newOwner].length - 1;
    }

}
