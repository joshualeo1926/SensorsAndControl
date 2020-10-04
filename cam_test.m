close all;
clear all;
clc;

fetch_con = Fetch();
tracker = image_track(true);


for i=0:1
    rgb_data = fetch_con.get_rgb_image();
    img = readImage(rgb_data);
    [target_found, x_err, x_pixel, y_pixel] = tracker.get_error(img);
end
