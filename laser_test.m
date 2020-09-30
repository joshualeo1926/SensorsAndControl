close all;
clear all;
clc;

Fetch_1 = Fetch();
Laser_1 = Laser();

data1 = Fetch_1.get_laser_data();

colCheck = Laser_1.return_distance(data1, 2)