function dydt = si_model(t,y,pars)
% function dydt = si_model(t,y,pars)
% SI Model — recovered individuals immediately become susceptible again
S = y(1);
I = y(2);

dSdt = -pars.beta*S*I + pars.gamma*I;
dIdt =  pars.beta*S*I - pars.gamma*I;

dydt = [dSdt; dIdt];
end
