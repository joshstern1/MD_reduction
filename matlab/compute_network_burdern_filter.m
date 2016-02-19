%Purpose: compute the network burdern could be saved when filtering before
%the multicast
%input: r2c, (r2c should be smaller than 1)
%this unit will distribute the packets marked in the multicast entry to their destinations
%
%Author: Jiayi Sheng
%Organization: CAAD lab @ Boston University%
%Start date: Jan 14th 2015


r2c=1:0.1:5;
particle_per_cell=172;
% half shell for N3L
% home is 0,0,0
% neighbor1 node is (-1,0,0), (0,1,0), (0,0,1)
% in total is 3
% neighbor2 node is (1,0,1), (0,1,1), (0,-1,1),(-1,0,1),(-1,1,0),(-1,-1,0) 
% in total is 6
% neighbor 3 node is (-1,-1,1),(1,-1,1),(-1,1,1),(1,1,1)
% in total is 4
neighbor1=3;
neighbor2=6;
neighbor3=4;
particle_per_box=172.*(r2c.^3);

volume_before_filtering=particle_per_box*neighbor1*1+particle_per_box*neighbor2*2+particle_per_box*neighbor3*3;

ratio1=particle_per_box./r2c;
ratio2=particle_per_box./(r2c.^2);
ratio3=172;

volume_after_filtering=ratio1*neighbor1*1+ratio2*neighbor2*2+ratio3*neighbor3*3;

volume_after_filtering_after_multicast=ratio1*neighbor1*1+ratio2*neighbor2*1+ratio3*neighbor3*1;

plot(r2c,volume_after_filtering./volume_before_filtering,'b');
hold on
plot(r2c,volume_after_filtering_after_multicast./volume_before_filtering,'r');
