close all;
clear all;
clc;

rosshutdown;
rosinit;


pid_rotation(setpoint = 0 deg)
pid_distance(setpoint = 1 meter)



#####|#####  = 0 px


###|####### = -40 px 

#######|### = 40 px


delta_rot = tracker.get_rot()
delta_dist = lidar.get_dist()

controlls_rot = pid_rotation.get_controlls(delta_rot)
controlls_dist = pid_distance.get_controlls(delta_dist)

fetch.move(controls_rot, controls_dist)


%CLASS - image tracking
%CLASS - distance tracking
%CLASS - PID
%CLASS - fetch
    %CLASS - collision

%CLASS - image tracking
    % tracker_located -> returns 1 if it can see the tracker, 0 if unfound
    % get_delta -> returns some delta of rotation
    
%CLASS - distance tracking
    % get_dist(rot) -> returns distance reading at input rotation
    
%CLASS - fetch
    % move -> always execute action
    % collision_move -> returns 1 if suc, 0 if predicted collision 

    
%while running
    %if we can see tracker
        % flag = true
        
    %if flag == true
        %figure out if we turn left or right
        %figure out if we are too close or too far away
        %see if anything is in the way or too close
            % if not
                % execute action
            % else
                % stop
    %else
        % rotate some ammount
        % look for tracker
        % if we can see tracker
            % flag = true
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    