function [t, mean_total, std_total, all_finals] = lab4_ensemble(info, predator, prey, n_ens)
% lab4_ensemble  Run n_ens stochastic replicates and return ensemble stats.
%
%   [t, mean_total, std_total, all_finals] = lab4_ensemble(info, predator, prey, n_ens)
%
% Returns the ensemble-mean cumulative eaten as a function of time
% (mean_total), its std (std_total), and the vector of final values
% across replicates (all_finals).

t      = 0:info.dt:info.tf;
numt   = length(t);
totals = zeros(n_ens, numt);

for ens = 1:n_ens
    % Re-randomize prey positions and initial predator angle each replicate
    prey.pos        = rand(prey.num, 2);
    prey.pos(:,1)   = prey.pos(:,1) * info.maxX;
    prey.pos(:,2)   = prey.pos(:,2) * info.maxY;
    predator.theta  = rand * 2*pi;
    predator.trun   = 0;

    [~, numeaten] = ibm_predation(info, predator, prey);
    totals(ens, :) = cumsum(numeaten);
end

mean_total = mean(totals, 1);
std_total  = std(totals, 0, 1);
all_finals = totals(:, end);
end
