% An individual-based model of predators eating prey
% Joshua Weitz

% Basic information
info.prey_density=10;	% density/cm^2
info.maxX=10;		% cm
info.maxY=10;		% cm
info.tf=50;		% sec
info.dt=0.1;		% Time step
info.replenish_prey=1;  % Should prey regenerate?
info.viz_dyn=1;		% 1 for animation, 0 for no animation

% Define the prey
prey.num=info.prey_density*info.maxX*info.maxY;
prey.pos=rand(prey.num,2);   % Random positions
prey.pos(:,1)=prey.pos(:,1)*info.maxX;
prey.pos(:,2)=prey.pos(:,2)*info.maxY;
prey.diffusion=0.005; 	% cm^2/sec

% Place the predator
predator.pos=[info.maxX/2 info.maxY/2];
predator.theta=rand*2*pi;  % Angle of movement
predator.r=1.25;		   % Radius
predator.k=0.3;		   % Detection	
predator.f=0.05;		   %  Successful capture per time
predator.vel=0.1; 	   % cm/sec
predator.handling_time=0.0;   % seconds
predator.tau=6;		   % Run time length, seconds
predator.trun=0;	   % Initialize each run

% % Simulate eating
% more off
% for ens=1:1,
%   ens
%   [t,numeaten]=ibm_predation(info,predator,prey);
%   total_eaten=cumsum(numeaten);
%   totend(ens)=total_eaten(end);
% end

% Simulate eating
[t,numeaten]=ibm_predation(info,predator,prey);
total_eaten=cumsum(numeaten);
