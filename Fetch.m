classdef Fetch < handle
    properties
       img_sub
       laser_sub
       control_pub
       control_msg
    end
    
    methods
        function self = Fetch()
            rosshutdown;
            rosinit;
            self.img_sub = rossubscriber('/head_camera/rgb/image_raw', 'sensor_msgs/Image');
            self.laser_sub = rossubscriber('/base_scan_raw', 'sensor_msgs/LaserScan');
            [self.control_pub, self.control_msg] = rospublisher('/cmd_vel', 'geometry_msgs/Twist');
            self.control_msg.Linear.X = 0;
            self.control_msg.Angular.Z = 0;
        end
        
        function rgb_data = get_rgb_image(self)
            rgb_data = receive(self.img_sub);
        end
        
        function laser_data = get_laser_data(self)
            laser_data = receive(self.laser_sub);
        end
        
        function linear_move(self, control)
            self.control_msg.Linear.X = control;
            self.publish_move()
        end
        
        function angular_move(self, control)
            self.control_msg.Angular.Z = control;
            self.publish_move()
        end
        
        function publish_move(self)
            send(self.control_pub, self.control_msg)
        end
    end
end