%% y=kx+b;
k1=1.04;
k2=-0.43511;
k3=0.552548;
k4=-0.922548;
x=-10:100;
y1=3.6*(k1*x-10); %% y轴是km/h 为x轴的3.6倍
y2=k2*x+50;
y3=k3*x;
y4=k4*x+50;
figure;
plot(x,y1,"r-");
hold on;
plot(x,y2,"b-");
hold on;
plot(x,y3,"k-");
hold on;
plot(x,y4,"g-");
hold on;
axis([0 200 0 200/3.6]);%% 设定x，y轴的范围