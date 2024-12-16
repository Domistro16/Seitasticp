// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "./Admin.sol";
import "./User.sol";

contract CourseContract {

    struct Quiz {
        uint256 id;
        string questionText;
        string[] options; // Multiple choice options
        uint8 correctAnswer; // Index of the correct option (0-based)
    }

    struct Lesson {
        uint256 id;
        string lessontitle;
        string url;
        string description;
        Quiz[] quizzes;
    }
    struct Course {
    uint256 id;
    string title;
    string description;
    string url;
    Lesson[] lessons;
    string isfree;
    mapping(address => bool) isEnrolled;
    address[] participants;
    string level;
}

    AdminContract public adminContract;
    UserContract public userContract;


    uint256 public courseCounter;
    mapping(uint256 => Course) public courses;

    event CourseAdded(uint256 indexed id, string title);
    event QuizAdded(uint256 indexed courseId, uint256 lessonId, uint256 quizId, string title);
    event LessonAdded(uint256 indexed courseId, uint256 lessonId, string title);


    constructor(address _adminContract, address _userContract) {
        adminContract = AdminContract(_adminContract);
        userContract = UserContract(_userContract);
    }

    modifier onlyAdmin() {
        require(msg.sender == adminContract.admin(), "Only admin can perform this action");
        _;
    }

    function addCourse(string memory _title, string memory _description, string memory _level, string memory _url, string memory _isfree) public onlyAdmin {

        Course storage c = courses[courseCounter];
        c.id = courseCounter;
        c.title = _title;
        c.description = _description;
        c.level = _level;
        c.url = _url;
        c.isfree = _isfree;
        emit CourseAdded(courseCounter, _title);
        courseCounter = courseCounter + 1;
    }
    function numCourses() public view returns (uint256){
        return courseCounter;
    }
function enroll(uint _id, address _user) public {
    require(_id < courseCounter, "Course does not exist");
    require(!courses[_id].isEnrolled[_user], "User is already enrolled");

    userContract.enrollInCourse(_user, _id);
    courses[_id].isEnrolled[_user] = true; // Mark as enrolled
    courses[_id].participants.push(_user);
}

    function getCourse(uint256 _id, address _user)
    public
    view
    returns (
        uint256,
        string memory title,
        string memory description,
        string memory url,
        Lesson[] memory lessons,
        string memory level,
        address[] memory participants,
        bool enrolled,
        string memory isfree,
        uint8 progress,
        uint256[] memory lessonIds
    )
{
    require(_id < courseCounter, "Course does not exist");

    Course storage course = courses[_id];
    bool isEnrolled = course.isEnrolled[_user]; // Direct lookup
    uint8 userProgress = isEnrolled ? userContract.getUserProgress(_user, _id) : 0;
    uint256[] memory ids = userContract.getCompletedLessons(_user, _id);

    return (course.id ,course.title, course.description, course.url, course.lessons, course.level, course.participants , isEnrolled, course.isfree, userProgress, ids);
}



    function addQuiz(uint256 _courseId, uint256 _lessonid, string memory _questionText, string[] memory _options, uint8 _correctAnswer) public onlyAdmin {
        require(_courseId < courseCounter, "Course does not exist");
        require(_correctAnswer < _options.length, "Invalid correct answer index");

        Quiz storage newQuiz = courses[_courseId].lessons[_lessonid].quizzes.push();
        newQuiz.id = courses[_courseId].lessons[_lessonid].quizzes.length - 1;
        newQuiz.questionText = _questionText;
        newQuiz.options = _options;
        newQuiz.correctAnswer = _correctAnswer;

        emit QuizAdded(_courseId, _lessonid, newQuiz.id, _questionText);
    }

      function addLesson(uint256 _courseId, string memory _text, string memory _url, string memory _description) public onlyAdmin {
        require(_courseId < courseCounter, "Course does not exist");

        Lesson storage newLesson = courses[_courseId].lessons.push();
        newLesson.id = courses[_courseId].lessons.length - 1;
        newLesson.lessontitle = _text;
        newLesson.description = _description;
        newLesson.url = _url;
        emit LessonAdded(_courseId, newLesson.id, _text);
    }
}
