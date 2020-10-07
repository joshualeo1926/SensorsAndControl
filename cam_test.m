close all;
clear all;
clc;

target_dist = 1;
collision_threshold = 0.25;

fetch_con = Fetch();
tracker = image_track(false);
depth_sensor = depth_sense(false);
laser_sensor = Laser(collision_threshold);

ang_pid = PID_controller(0, 3, 0, 0.5);
dst_pid = PID_controller(target_dist, 1.5, 0, 1);

searching_angular_speed = 0;
re_aquire_window = 10;

last_ang_command = 0.3;
last_lin_command = 0;
for i=0:2000
    
    rgb_data = fetch_con.get_rgb_image();
    [target_found, x_err, x_pixel, y_pixel] = tracker.get_error(rgb_data);

    depth_data = fetch_con.get_depth_image();
    [dst, min_dist] = depth_sensor.get_distance(depth_data, x_pixel, y_pixel);
    
    laser_data = fetch_con.get_laser_data();
    is_laser_collision = laser_sensor.check_collision(laser_data);
    if min_dist >= collision_threshold && ~is_laser_collision
        if target_found && ~isnan(dst)
            ang_control = ang_pid.get_control(x_err);

            dst_control = min(max(dst_pid.get_control(dst), -1), 1);

            fetch_con.linear_move(-dst_control);
            fetch_con.angular_move(ang_control);
            last_ang_command = ang_control;
            last_lin_command = -dst_control;
        else
            fetch_con.angular_move(sign(last_ang_command)*0.35);
            fetch_con.linear_move(0);        
        end 
    else
        'acoiding upcomming collision'
    end
end
