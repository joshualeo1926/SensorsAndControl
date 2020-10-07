classdef PID_controller < handle
    properties
        Kp;
        Ki;
        Kd;

        last_time;
        last_error;
        total_error;
        error;
        set_point;
    end

    methods
        function self = PID_controller(set_point, Kp, Ki, Kd)
            if nargin > 3
                self.set_point = set_point;
                self.Kp = Kp;
                self.Ki = Ki;
                self.Kd = Kd;
            else
                self.set_point = 1;
                self.Kp = 1;
                self.Ki = 1;
                self.Kd = 1;
            end    
        end

        function [output] = get_control(self, input_)
            current_time = cputime;
            d_t = current_time - self.last_time;
            error_ = self.set_point - input_;
            if isempty(self.last_time)
                d_error = 0;
                self.total_error = 0;
            else
                d_error = error_ - self.last_error;
                self.total_error = self.total_error + error_ * d_t;
            end
            
            output = self.Kp * error_ + self.Ki * self.total_error + self.Kd * d_error;

            self.last_time = current_time;
            self.last_error = error_;
        end
    end
end