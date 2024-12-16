// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract UserContract {
    struct User {
        string name;
        address walletAddress;
        bool registered;
        uint256 enrolled;
        mapping(uint256 => uint8) courseProgress; // Maps courseId to progress (0-100%)
        mapping(uint256 => uint256[]) completedLessons;
    }

    mapping(address => User) public users;

    event UserRegistered(address indexed walletAddress);
    event CourseEnrolled(address indexed user, uint256 courseId);
    event ProgressUpdated(address indexed user, uint256 courseId, uint8 progress);

    uint256 public userCounter;
    function register(string memory _name) public {
        require(!users[msg.sender].registered, "User already registered");
        User storage user = users[msg.sender];
        user.name = _name;
        user.walletAddress = msg.sender;
        user.registered = true;

        userCounter = userCounter + 1;
        emit UserRegistered(msg.sender);
    }

    function getUser(address _id) public view returns (
        string memory name,
        address walletAddress,
        bool isRegistered,
        uint256
    ){
        require(users[_id].walletAddress != address(0), "User doesn't exist");
        User storage u = users[_id];
       return (u.name, u.walletAddress, u.registered, u.enrolled);

    }


    function getUsers() public view returns (
        uint256
    ){
        return userCounter;
    }


    function enrollInCourse(address _user, uint256 _courseId) public {
        require(users[_user].registered, "User must be registered");

        users[_user].courseProgress[_courseId] = 10; // Initialize progress
        users[_user].enrolled = users[_user].enrolled + 1;
        emit CourseEnrolled(_user, _courseId);
    }

    function updateCourseProgress(uint256 _courseId, uint256 _lessonId, uint8 _progress) public {
        require(users[msg.sender].registered, "User must be registered");
        require(users[msg.sender].courseProgress[_courseId] > 0 || _progress == 0, "Not enrolled in this course");
        require(_progress <= 100, "Progress cannot exceed 100%");

        users[msg.sender].courseProgress[_courseId] = _progress;
        users[msg.sender].completedLessons[_courseId].push(_lessonId);
        emit ProgressUpdated(msg.sender, _courseId, _progress);
    }

    function getUserProgress(address _user, uint256 _courseId) public view returns (uint8) {        
        return users[_user].courseProgress[_courseId];
    }

    function getCompletedLessons(address _user, uint256 _courseId) public view returns(uint256[] memory){
            return users[_user].completedLessons[_courseId];
    }

    function migrateUser(
        string memory _name,
        uint256 _enrolled,
        uint256[] memory _courseIds,
        uint8[] memory _progresses
    ) public{
        require(_courseIds.length == _progresses.length, "Mismatched inputs");
        
        User storage user = users[msg.sender];
        user.name = _name;
        user.enrolled = _enrolled;

        for (uint256 i = 0; i < _courseIds.length; i++) {
            user.courseProgress[_courseIds[i]] = _progresses[i];
        }
    }
}
