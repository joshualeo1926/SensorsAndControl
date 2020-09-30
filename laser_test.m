close all;
clear all;
clc;

Fetch_1 = Fetch();
Laser_1 = Laser();

data1 = Fetch_1.get_laser_data();

colCheck = Laser_1.check_collision(data1, 2)