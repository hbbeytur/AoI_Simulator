clear
mu = 7;
lambdai = 2;
lambda = 2;
q = (mu*lambdai)/(lambda*(lambda+mu));

Y = 1/(q*lambda);
YY=(2-q)/(lambda^2*q^2);
YY2 = (2)/((lambda*q)^2);
YY3 = (2-q)/((lambda*q)^2);

T = 1/(lambda+mu);

a1 = T + 0.5*YY3/Y

D = (lambda + mu)/(lambdai*mu);
DD = 2*(lambda/lambdai)*((lambda/lambdai)*(1/lambda + 1/mu)^2-1/(lambda*mu));

a2 = T + 0.5*DD/D