function [info, predator, prey] = lab4_default_params()
% lab4_default_params  Return (info, predator, prey) with the defaults
%                      from master_ibm.m. Animation is disabled.
%
% Usage:
%   [info, predator, prey] = lab4_default_params();
%   info.tf = 100;            % then override what you need
%   predator.r = 0.5;
%   [t, numeaten] = ibm_predation(info, predator, prey);

% Basic information
info.prey_density   = 10;     % density / cm^2
info.maxX           = 10;     % cm
info.maxY           = 10;     % cm
info.tf             = 50;     % seconds
info.dt             = 0.1;    % time step
info.replenish_prey = 1;      % regenerate eaten prey?
info.viz_dyn        = 0;      % 0 = no animation (much faster for sweeps)

% Define the prey
prey.num        = info.prey_density * info.maxX * info.maxY;
prey.pos        = rand(prey.num, 2);
prey.pos(:,1)   = prey.pos(:,1) * info.maxX;
prey.pos(:,2)   = prey.pos(:,2) * info.maxY;
prey.diffusion  = 0.005;     % cm^2/sec

% Place the predator
predator.pos           = [info.maxX/2, info.maxY/2];
predator.theta         = rand * 2*pi;
predator.r             = 1.25;
predator.k             = 0.3;
predator.f             = 0.05;
predator.vel           = 0.1;
predator.handling_time = 0.0;
predator.tau           = 6;
predator.trun          = 0;
end
