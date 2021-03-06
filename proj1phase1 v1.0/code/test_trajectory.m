% Used for HKUST ELEC 5660

close all;
clc;
addpath('./utils','./readonly');
figure(1)
h1 = subplot(3,4,1);
h2 = subplot(3,4,2);
h3 = subplot(3,4,3);
h4 = subplot(3,4,4);
h5 = subplot(3,4,6);
h6 = subplot(3,4,7);
h7 = subplot(3,4,8);
h8 = subplot(3,4,10);
h9 = subplot(3,4,11);
h10 = subplot(3,4,12);
set(gcf, 'Renderer', 'painters');

global count pos_des_last vel_des_last ss_pos ss_vel
count = 0;
pos_des_last = [0;0;0];
ss_pos = 0;
vel_des_last = [0;0;0];
ss_vel = 0;


% Run Trajectory  three trajectories, test one by one
% run_trajectory_readonly(h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, @hover_trajectory);
% run_trajectory_readonly(h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, @circle_trajectory);
 run_trajectory_readonly(h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, @diamond_trajectory);


 rms_pos=sqrt(ss_pos/(count-1));
 rms_vel=sqrt(ss_vel/(count-1));
 disp(rms_pos);
 disp(rms_vel);
