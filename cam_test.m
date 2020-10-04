close all;
clear all;
clc;

fetch_con = Fetch();
tracker = image_track(true);
vel_pid = PID_controller(0, 2.5, 0, 0.5);

searching_angular_speed = 0;
for i=0:500
    
    rgb_data = fetch_con.get_rgb_image();
    [target_found, x_err, x_pixel, y_pixel] = tracker.get_error(rgb_data);

    if target_found
        control = vel_pid.get_control(x_err)
        fetch_con.angular_move(control);

    end
end
