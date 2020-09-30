close all;
clear all;
clc;

fetch_con = Fetch();

for i=0:10
    rgb_data = fetch_con.get_rgb_image();
    img = readImage(rgb_data);
    imshow(img);
end
