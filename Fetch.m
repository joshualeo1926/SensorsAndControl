classdef Fetch < handle
    properties
       img_sub
       laser_sub
    end
    
    methods
        function self = Fetch(self)
            rosshutdown;
            rosinit;
            self.img_sub = rossubscriber('/head_camera/rgb/image_raw', 'sensor_msgs/Image');
            self.laser_sub = rossubscriber('/base_scan_raw', 'sensor_msgs/LaserScan');
        end
        
        function rgb_data = get_rgb_image(self)
            rgb_data = receive(self.img_sub);
        end
        
        function laser_data = get_laser_data(self)
            laser_data = receive(self.laser_sub);
        end
    end
end