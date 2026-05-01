function [t,y] = stochsim_SIR(trange,y0,pars)
% function [t,y] = stochsim_SIR(trange,y0,pars)
%
% Simulates an SIR model via the Gillespie algorithm
% from t0 to tf in trange given initial
% conditions in y0 = [S0 I0 R0] (absolute counts) and parameters in pars.
%
% Two events:
%   Infection:  S+I -> 2I   rate r1 = beta*S*I/N
%   Recovery:   I   -> R    rate r2 = gamma*I

t0 = trange(1);
tf = trange(2);

t(1)    = t0;
y(1,:)  = y0;
tcur    = t0;
ycur    = y0;   % [S I R] as integers
ind     = 1;

while (tcur < tf)

    % --- If no infectious individuals remain, epidemic is over ---
    if (ycur(2) == 0)
        ind       = ind + 1;
        t(ind)    = tf;
        y(ind,:)  = ycur;
        break;
    end

    % --- Compute event rates ---
    infrate = pars.beta * ycur(1) * ycur(2) / pars.N;   % beta*S*I/N
    recrate = pars.gamma * ycur(2);                       % gamma*I
    totrate = infrate + recrate;

    % --- Time to next event (exponentially distributed) ---
    dt   = -1/totrate * log(rand);
    tcur = tcur + dt;

    % --- Choose which event occurs ---
    if (rand < (infrate / totrate))   % INFECTION: S -> I
        ycur(1) = ycur(1) - 1;       %   S decreases by 1
        ycur(2) = ycur(2) + 1;       %   I increases by 1
    else                              % RECOVERY:  I -> R
        ycur(2) = ycur(2) - 1;       %   I decreases by 1
        ycur(3) = ycur(3) + 1;       %   R increases by 1
    end

    ind       = ind + 1;
    t(ind)    = tcur;
    y(ind,:)  = ycur;
end
end
