close all;
clear all;
clc;

fetch_con = Fetch();
tracker = image_track(true);
depth_sensor = depth_sense(true);

ang_pid = PID_controller(0, 2.5, 0, 0.5);
dst_pid = PID_controller(2, 1.5, 0, 0.15);

searching_angular_speed = 0;
last_found_time = 0;
re_aquire_window = 5;
for i=0:2000
    
    rgb_data = fetch_con.get_rgb_image();
    [target_found, x_err, x_pixel, y_pixel] = tracker.get_error(rgb_data);

    if target_found
        ang_control = ang_pid.get_control(x_err);
        
        depth_data = fetch_con.get_depth_image();
        [dst, min_dist] = depth_sensor.get_distance(depth_data, x_pixel, y_pixel);
        dst_control = min(max(dst_pid.get_control(dst), -1), 1);
        
        
        fetch_con.linear_move(-dst_control);
        fetch_con.angular_move(ang_control);
        
        last_found_time = cputime * 1000;
        
    elseif (cputime * 1000) - last_found_time >= re_aquire_window
        fetch_con.angular_move(0.25);
        fetch_con.linear_move(0);
    end
end
