clear;

particle_num=[1e3,2e3,5e3,1e4,2e4,5e4,1e5,2e5,5e5,1e6,2e6,5e6,1e7];

nodes_num=[16,32,64,128,256,512,1024,2048,4096];

pair_limit=44; %44 phits is the communication volume between each pair to avoid congestion

latency_constant=[4,10,20];

%nodes_num=2^m1
%fft size=2^(3*FFT_N)
%number of nodes for FFT=2^m2

for i=1:1:length(nodes_num)
    m1=log2(nodes_num(i));
    if nodes_num(i)<24
        latency_constant1=4;
    elseif nodes_num(i)<1000
        latency_constant1=8;
    else
        latency_constant1=20;
    end
    for j=1:1:length(particle_num)
        FFT_N=floor(log2(nthroot(particle_num(j),3)));
     
        m2_lower_limit=ceil(1.5*FFT_N-3.5);
        m2_upper_limit=m1;
        
        for m2=m2_lower_limit:1:m2_upper_limit
            FFT_node_num=2^m2;
            if FFT_node_num<24
                latency_constant2=4;
            elseif FFT_node_num<1000
                latency_constant2=8;
            else
                latency_constant2=20;
            end
            gather_latency=2^(3*FFT_N-m2)/625+latency_constant1;
            corner_turn_latency=2^(3*FFT_N-2*m2)*(2^m2-1)/625+latency_constant2;
            scatter_latency=gather_latency;
            total_latency(i,m2,FFT_N)=gather_latency+4*corner_turn_latency+scatter_latency;
        end
    end
end

for i=1:1:length(total_latency(:,1,1))
    for j=1:1:length(total_latency(1,:,1))
        for k=1:1:length(total_latency(1,1,:))
            if(total_latency(i,j,k)==0)
                total_latency(i,j,k)=NaN;
            end
        end
    end
end

%plot FFT size 8^3


figure(1);
%subplot(151);


semilogx(nodes_num,total_latency(:,1,3),'r-+');
hold on
semilogx(nodes_num,total_latency(:,2,3),'b-+');
semilogx(nodes_num,total_latency(:,3,3),'k-+');
semilogx(nodes_num,total_latency(:,4,3),'r-x');
semilogx(nodes_num,total_latency(:,5,3),'b-x');
semilogx(nodes_num,total_latency(:,6,3),'k-x');
semilogx(nodes_num,total_latency(:,7,3),'r-*');
semilogx(nodes_num,total_latency(:,8,3),'b-*');
semilogx(nodes_num,total_latency(:,9,3),'k-*');
semilogx(nodes_num,total_latency(:,10,3),'r-o');
semilogx(nodes_num,total_latency(:,11,3),'b-o');
semilogx(nodes_num,total_latency(:,12,3),'k-o');
legend('fft nodes 2','fft nodes 4','fft nodes 8','fft nodes 16','fft nodes 32','fft nodes 64','fft nodes 128','fft nodes 256','fft nodes 512','fft nodes 1024','fft nodes 2048','fft nodes 4096');

xlabel('number of total nodes');
ylabel('FFT latency(us)');
title('FFT latency for 8^3');


figure(2);
%subplot(151);


semilogx(nodes_num,total_latency(:,1,4),'r-+');
hold on
semilogx(nodes_num,total_latency(:,2,4),'b-+');
semilogx(nodes_num,total_latency(:,3,4),'k-+');
semilogx(nodes_num,total_latency(:,4,4),'r-x');
semilogx(nodes_num,total_latency(:,5,4),'b-x');
semilogx(nodes_num,total_latency(:,6,4),'k-x');
semilogx(nodes_num,total_latency(:,7,4),'r-*');
semilogx(nodes_num,total_latency(:,8,4),'b-*');
semilogx(nodes_num,total_latency(:,9,4),'k-*');
semilogx(nodes_num,total_latency(:,10,4),'r-o');
semilogx(nodes_num,total_latency(:,11,4),'b-o');
semilogx(nodes_num,total_latency(:,12,4),'k-o');
legend('fft nodes 2','fft nodes 4','fft nodes 8','fft nodes 16','fft nodes 32','fft nodes 64','fft nodes 128','fft nodes 256','fft nodes 512','fft nodes 1024','fft nodes 2048','fft nodes 4096');

xlabel('number of total nodes');
ylabel('FFT latency(us)');
title('FFT latency for 16^3');

figure(3);
%subplot(151);


semilogx(nodes_num,total_latency(:,1,5),'r-+');
hold on
semilogx(nodes_num,total_latency(:,2,5),'b-+');
semilogx(nodes_num,total_latency(:,3,5),'k-+');
semilogx(nodes_num,total_latency(:,4,5),'r-x');
semilogx(nodes_num,total_latency(:,5,5),'b-x');
semilogx(nodes_num,total_latency(:,6,5),'k-x');
semilogx(nodes_num,total_latency(:,7,5),'r-*');
semilogx(nodes_num,total_latency(:,8,5),'b-*');
semilogx(nodes_num,total_latency(:,9,5),'k-*');
semilogx(nodes_num,total_latency(:,10,5),'r-o');
semilogx(nodes_num,total_latency(:,11,5),'b-o');
semilogx(nodes_num,total_latency(:,12,5),'k-o');
legend('fft nodes 2','fft nodes 4','fft nodes 8','fft nodes 16','fft nodes 32','fft nodes 64','fft nodes 128','fft nodes 256','fft nodes 512','fft nodes 1024','fft nodes 2048','fft nodes 4096');

xlabel('number of total nodes');
ylabel('FFT latency(us)');
title('FFT latency for 32^3');

figure(4);
%subplot(151);


semilogx(nodes_num,total_latency(:,1,6),'r-+');
hold on
semilogx(nodes_num,total_latency(:,2,6),'b-+');
semilogx(nodes_num,total_latency(:,3,6),'k-+');
semilogx(nodes_num,total_latency(:,4,6),'r-x');
semilogx(nodes_num,total_latency(:,5,6),'b-x');
semilogx(nodes_num,total_latency(:,6,6),'k-x');
semilogx(nodes_num,total_latency(:,7,6),'r-*');
semilogx(nodes_num,total_latency(:,8,6),'b-*');
semilogx(nodes_num,total_latency(:,9,6),'k-*');
semilogx(nodes_num,total_latency(:,10,6),'r-o');
semilogx(nodes_num,total_latency(:,11,6),'b-o');
semilogx(nodes_num,total_latency(:,12,6),'k-o');
legend('fft nodes 2','fft nodes 4','fft nodes 8','fft nodes 16','fft nodes 32','fft nodes 64','fft nodes 128','fft nodes 256','fft nodes 512','fft nodes 1024','fft nodes 2048','fft nodes 4096');

xlabel('number of total nodes');
ylabel('FFT latency(us)');
title('FFT latency for 64^3');

figure(5);
%subplot(151);


semilogx(nodes_num,total_latency(:,1,7),'r-+');
hold on
semilogx(nodes_num,total_latency(:,2,7),'b-+');
semilogx(nodes_num,total_latency(:,3,7),'k-+');
semilogx(nodes_num,total_latency(:,4,7),'r-x');
semilogx(nodes_num,total_latency(:,5,7),'b-x');
semilogx(nodes_num,total_latency(:,6,7),'k-x');
semilogx(nodes_num,total_latency(:,7,7),'r-*');
semilogx(nodes_num,total_latency(:,8,7),'b-*');
semilogx(nodes_num,total_latency(:,9,7),'k-*');
semilogx(nodes_num,total_latency(:,10,7),'r-o');
semilogx(nodes_num,total_latency(:,11,7),'b-o');
semilogx(nodes_num,total_latency(:,12,7),'k-o');
legend('fft nodes 2','fft nodes 4','fft nodes 8','fft nodes 16','fft nodes 32','fft nodes 64','fft nodes 128','fft nodes 256','fft nodes 512','fft nodes 1024','fft nodes 2048','fft nodes 4096');

xlabel('number of total nodes');
ylabel('FFT latency(us)');
title('FFT latency for 128^3');



