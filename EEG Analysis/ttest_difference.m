%%t-test
x1 = 9.3425;
x2 = 10.5794;

se1 = 11.69 - x1;
se2 = 12.7916 - x2;

n1 = 55;
n2 = 55;

sd1 = se1*sqrt(n1);
sd2 = se2*sqrt(n2);
denom = sqrt(((sd1^2)/n1) + ((sd2^2)/n2));
t = (x1 - x2) / denom;


v = (n1-1)+(n2-1);
tdist2T = (1-betainc(v/(v+t^2),v/2,0.5));    % 2-tailed t-distribution
% tdist1T = 1-(1-tdist2T(t,v))/2;              % 1-tailed t-distribution