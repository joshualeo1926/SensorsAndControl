close all;
clear all;
clc;

target_dist = 1;
collision_threshold = 0.25;

fetch_con = Fetch();
tracker = image_track(true);
laser_sensor = Laser(collision_threshold);
depth_sensor = depth_sense(false);

ang_pid = PID_controller(0, 2.5, 0.75, 3);
dst_pid = PID_controller(1, 1.5, 0, 1);

last_ang_command = 1;
x_err = 0.5;
x_err_mat = [];
times = [];
i=0;
init_time = cputime;
while cputime-init_time < 15
    i = i +1;
    rgb_data = fetch_con.get_rgb_image();
    [target_found, x_err, x_pixel, y_pixel] = tracker.get_error(rgb_data);
    depth_data = fetch_con.get_depth_image();
    [dst, min_dist] = depth_sensor.get_distance(depth_data, x_pixel, y_pixel);
    if target_found && cputime-init_time > 5
        ang_control = ang_pid.get_control(x_err);
        dst_control = min(max(dst_pid.get_control(dst), -1), 1);

        %fetch_con.linear_move(-dst_control);
        fetch_con.angular_move(ang_control);
        
        
        x_err_mat = [x_err_mat, (1-abs(dst)-0.008)];
        times = [times, ; cputime-init_time];
        %plot(times, x_err_mat, 'r');      
    elseif cputime-init_time >10
        fetch_con.angular_move(sign(last_ang_command));
        fetch_con.linear_move(0);        
            
    end
end