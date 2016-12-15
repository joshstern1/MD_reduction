inject_rate0=data(:,1);
online0=data(:,2);
offline0=data(:,3);

figure
subplot(1,5,1);
grid on;
plot(inject_rate0,online0,'b','Linewidth',3);
hold on
plot(inject_rate0,offline0,'r','Linewidth',3);
%xlabel('Injection rate (packtes/cycle/node)');
ylabel('latency(ns)');
%legend('online routing','offline routing');
title('all-to-all');

inject_rate1=data(:,4);
online1=data(:,5);
offline1=data(:,6);

subplot(1,5,2);
grid on;
plot(inject_rate1,online1,'b','Linewidth',3);
hold on
plot(inject_rate1,offline1,'r','Linewidth',3);
title('random (nodes ratio=0.5');
%xlabel('Injection rate (packtes/cycle/node)');
%ylabel('latency(ns)');
%legend('online routing','offline routing');

inject_rate2=data(:,7);
online2=data(:,8);
offline2=data(:,9);

subplot(1,5,3);
grid on;
plot(inject_rate2,online2,'b','Linewidth',3);
hold on
plot(inject_rate2,offline2,'r','Linewidth',3);
title('random (nodes ratio=0.2');
xlabel('Injection rate (packtes/cycle/node)');
%ylabel('latency(ns)');
%legend('online routing','offline routing');

inject_rate3=data(:,10);
online3=data(:,11);
offline3=data(:,12);

subplot(1,5,4);
grid on;
plot(inject_rate3,online3,'b','Linewidth',3);
hold on
plot(inject_rate3,offline3,'r','Linewidth',3);
title('nearest neighbor');
%xlabel('Injection rate (packtes/cycle/node)');
%ylabel('latency(ns)');
%legend('online routing','offline routing');

inject_rate4=data(:,13);
online4=data(:,14);
offline4=data(:,15);

subplot(1,5,5);
grid on;
plot(inject_rate4,online4,'b','Linewidth',3);
hold on
plot(inject_rate4,offline4,'r','Linewidth',3);
title('bit rotation');
%xlabel('Injection rate (packtes/cycle/node)');
%ylabel('latency(ns)');
legend('online routing','offline routing');