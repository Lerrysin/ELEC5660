function [F, M] = controller(t, s, s_des)
% s:current state
% s_des:desied state

global params

m = params.mass;
g = params.grav;
I = params.I;

% s(1:3) current position 
% s(4:6) current velocity
% s(7:10) current attitude quaternion 
% s(11:13) current body angular velocity 

% s_des(1:3) desire position
% s_des(4:6) desire velocity   
% s_des(7:9) desire acceleration  
% s_des(10) desire yaw 
% s_des(11) desire yaw rate 

% RMS
global count pos_des_last vel_des_last ss_pos ss_vel

if count>0
    error_pos = pos_des_last-s(1:3);
    ss_pos = ss_pos+error_pos'*error_pos;
    error_vel = vel_des_last-s(4:6);
    ss_vel = ss_vel+error_vel'*error_vel;
end

count = count+1;
pos_des_last = s_des(1:3);
vel_des_last = s_des(4:6);

% 
kp_pos = [5,5,5];  
kd_pos = [8,8,8]; 
kp_rpy = [250,200,400];
kd_rpy = [20,20,30];

[roll,pitch,yaw] = RotToRPY_ZXY(quaternion_to_R(s(7:10)));
rpy = [roll,pitch,yaw];

% position control
pos_PIDControl_1 = s_des(7)+kd_pos(1)*(s_des(4)-s(4))+kp_pos(1)*(s_des(1)-s(1));
pos_PIDControl_2 = s_des(8)+kd_pos(2)*(s_des(5)-s(5))+kp_pos(2)*(s_des(2)-s(2));
pos_PIDControl_3 = s_des(9)+kd_pos(3)*(s_des(6)-s(6))+kp_pos(3)*(s_des(3)-s(3));

F = m*(g+pos_PIDControl_3);
roll_des = (pos_PIDControl_1*sin(yaw)-pos_PIDControl_2*cos(yaw))/g;
pitch_des = (pos_PIDControl_1*cos(yaw)+pos_PIDControl_2*sin(yaw))/g;


% attitude control
error_rpy = [roll_des-roll,pitch_des-pitch,s_des(10)-yaw];
% error_rpy = [-roll,-pitch,-yaw];
error_rpy_a = [0-s(11),0-s(12),s_des(11)-s(13)];

if error_rpy(3) >= pi
    error_rpy(3)=error_rpy(3)-2*pi;
elseif error_rpy(3) <= -pi
    error_rpy(3)=error_rpy(3)+2*pi;
end

angular_PIDControl = [kp_rpy(1)*error_rpy(1)+kd_rpy(1)*error_rpy_a(1);
    kp_rpy(2)*error_rpy(2)+kd_rpy(2)*error_rpy_a(2);
    kp_rpy(3)*error_rpy(3)+kd_rpy(3)*error_rpy_a(3)];

angular_v = s(11:13);
M = I*angular_PIDControl+cross(angular_v,I*angular_v);

% F = 1.0; 
% M = [0.0, 0.0, 0.0]'; % You should calculate the output F and M

end
