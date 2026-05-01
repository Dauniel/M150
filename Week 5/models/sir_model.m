function dydt = sir_model(t,y,pars)
% function dydt = sir_model(t,y,pars)
% SIR Model — fractions (S+I+R=1)
S = y(1);
I = y(2);

dSdt = -pars.beta*S*I;
dIdt =  pars.beta*S*I - pars.gamma*I;
dRdt =  pars.gamma*I;

dydt = [dSdt; dIdt; dRdt];
end
