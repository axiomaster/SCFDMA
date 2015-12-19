%% ≤Â÷µ≤‚ ‘
%% ºÚµ•≤Â÷µ≤‚ ‘
% x = 0:10;
% y = sin(x);
% 
% x1=0:0.25:10;
% y1=sin(x1);
% xx = 0:.25:10;
% yy = spline(x,y,xx);
% plot(x1,y1,'r-');
% hold on;
% plot(x,y,'o',xx,yy,'k-*');
% hold on;
% 
% x2=0:5;
% y2=sin(x2);
% 
% xx2=0:0.25:5;
% yy2=spline(x2,y2,xx2);
% plot(x2,y2,'o',xx2,yy2,'b-*');
% xlim([0 10]);

%% 
x = -4:4;
y = [0 .15 1.12 2.36 2.36 1.46 .49 .06 0];
cs = spline(x,[-1  y  1]);
xx = linspace(-4,4,101);
ppv=ppval(cs,xx);

xx1=-4:0.08:4;
yy1=spline(x,y,xx1);
plot(x,y,'o',xx,ppval(cs,xx),'-',xx1,yy1,'k-');
grid on;