# 41014 Sensors and Control

### Description
This GitHub repository contains all of the necessary files and scripts to achieve the "Group project 1: Fetch following the path".
Using ROS, and MATLAB we employ various sensing and control techniques learnt throughout this subject to complete the project brief.
some of these techniques are:
- SURF feature detection and image matching
- Image manipulation/transforming and co-ordinate transforms
- Laser sensing and analysis
- Depth image analysis
- PID control
- Passing data through ROS via subscriber and publishers

### Setup
along with the Fetch_gazebo dependencies we also need the turtle bot dependencies
- cd ~/catkin_ws/src/
- git clone https://github.com/ROBOTIS-GIT/turtlebot3.git
- git clone https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
- git clone https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git ##
- cd ~/catkin_ws
- catkin_make

From our GitHub repository
- git clone https://github.com/joshualeo1926/SensorsAndControl.git
- copy "node" folder from the git repo to ~/catkin_ws/src/fetch_gazebo/fetch_gazebo
- copy "assignment_environment.launch" from the git repo to ~/catkin_ws/src/fetch_gazebo/fetch_gazebo
- copy "marker_control.launch" from the git repo to ~/catkin_ws/src/fetch_gazebo/fetch_gazebo
- copy "assignment_world.sdf" from the git repo to ~/catkin_ws/src/fetch_gazebo/fetch_gazebo/worlds
- copy "turtlebot3_burger" folder from the git repo and replace the existing one in ~/catkin_ws/src/turtlebot3_simulations/turtlebot3_gazebo/models

### How to run
- cd ~/catkin_ws
- source devel/setup.bash

- Launch the simulation with:
	- roslaunch fetch_gazebo assignment_environment.launch

- Control the marker/guider with:
	- roslaunch fetch_gazebo marker_control.launch

- run main.m script from MATLAB

### Classes
- Fetch class [fetch.m]: contains our connection to ROS and has our getters and setters for the fetch robot such as the getters for the sensor data, and the setters to apply the control values.
	- get_rgb_image: returns RGB data from ROS.
	- get_laser_data: returns laser data from ROS.
	- get_depth_image: returns depth data from ROS.
	- linear_move: sets the linear velocity of the ROS message to be published.
	- angular_move: sets the angular velocity of the ROS message to be published.
	- publish_move: publishes the control message.

- Laser class [laser.m]: analyses our laser data and checks for collisions, and returns distance at a given point.
	- check_collision: takes laser data as an input and checks if it’s below a collision threshold, returns true if it is, otherwise, false.
	- return_distance: takes in laser data and an angle and returns the distance at that angle.

- PID class [PID_controller.m]: propotional, integral, differential controller class to be used to control the fetches linear and angular velocity based off the error to their set points.
	- get_control: takes in an error value as input and returns a output control value

- Image tracking class [image_track.m]: detects the target marker and returns an error from it to the centre of the screen/sensor.
	- get_error: takes in image data as an input, detects if the target image in present in data, and if so, returns a boolen flag if the marker is located, the x pixel error between the centre of the image and the centre of the marker, and the x/y pixel location of the markers centre

- Depth sensor class [depth_sense.m]: returns the distance at a given pixel location
	- get_distance: takes in depth data and a x/y pixel location and returns the distance at that point.

### Code structure
- Get RGB data from fetch
- Detect marker and get error
- Get depth data from fetch
- Get distance from marker
- Get Laser data from fetch
- Check for collisions, if a collision is detected, stop all movement and print "avoiding upcoming collision"
- If the marker is found, run the error through an angular control PID and the distance through a linear control PID and apply control values
- Else, rotate on spot to find marker

### Contributions

Jonathan Wilde - 12545606: 50%
- Code structure and class design
- Main layout
- Fetch class development
- Laser class lead development
- Depth class sensor lead development
- Image tracking feedback and help
- PID tuning
- Testing 
- Environment

Joshua Leo - 125835687: 50%
- Code stucture and class design
- Main layout
- Fetch class development
- Image tacking class lead development
- PID class lead development
- Laser class feedback and help
- PID tuning
- Testing
- Guider/Marker model, texture and movement


