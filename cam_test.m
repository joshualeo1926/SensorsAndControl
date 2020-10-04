close all;
clear all;
clc;

fetch_con = Fetch();
tracker = image_track(true);
depth_sensor = depth_sense(true);

ang_pid = PID_controller(0, 2.5, 0, 0.5);
dst_pid = PID_controller(2, 1.5, 0, 0.15);

searching_angular_speed = 0;
for i=0:2000
    
    rgb_data = fetch_con.get_rgb_image();
    [target_found, x_err, x_pixel, y_pixel] = tracker.get_error(rgb_data);

    if target_found
        ang_control = ang_pid.get_control(x_err);
        
        depth_data = fetch_con.get_depth_image();
        if x_pixel < 480
            depth_image = readImage(depth_data);
            dst = depth_image(x_pixel, y_pixel)
            if isnan(dst)
                fetch_con.linear_move(0);
            else
                dst_control = min(max(dst_pid.get_control(dst), -1), 1);
                fetch_con.linear_move(-dst_control);
            end
        else
            fetch_con.linear_move(0);
        end
        fetch_con.angular_move(ang_control);
        
        
    else
        x = 2
        %fetch_con.angular_move(0.5);
        %fetch_con.linear_move(0);
    end
end
