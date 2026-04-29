% lab4_exercise_1a.m
% Exercise 1a: test whether reducing the detection radius r decreases
% the number of prey eaten by a factor of r^2 (i.e. r=0.5 should give
% ~1/4 the prey of r=1.0).

clear; clc;
n_ens     = 20;                 % ensemble size for averaging
r_values  = [1.25, 1.0, 0.5];   % radii to test
finals    = zeros(size(r_values));

figure; hold on;
colors = lines(length(r_values));

for i = 1:length(r_values)
    [info, predator, prey] = lab4_default_params();
    predator.r = r_values(i);
    [t, m, s, ~] = lab4_ensemble(info, predator, prey, n_ens);
    plot(t, m, 'LineWidth', 2, 'Color', colors(i,:), ...
         'DisplayName', sprintf('r = %.2f  (final = %.1f \\pm %.1f)', ...
                                r_values(i), m(end), s(end)));
    fill([t fliplr(t)], [m+s fliplr(m-s)], colors(i,:), ...
         'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
    finals(i) = m(end);
    fprintf('r = %.2f : final eaten = %.2f +/- %.2f\n', r_values(i), m(end), s(end));
end

xlabel('time (s)'); ylabel('cumulative prey eaten');
title('Exercise 1a: effect of detection radius');
legend('Location', 'northwest'); grid on;

% Check the squared-scaling hypothesis
ratio_meas = finals(2) / finals(3);            % r=1.0 / r=0.5
ratio_pred = (r_values(2) / r_values(3))^2;    % should be 4
fprintf('\nRatio (r=1.0)/(r=0.5): measured = %.2f, predicted r^2 = %.2f\n', ...
        ratio_meas, ratio_pred);
