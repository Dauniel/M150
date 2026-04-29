% lab4_exercise_1c.m
% Exercise 1c: Does the diffusion coefficient of prey modify the
% consumption rate of predators?

clear; clc;
n_ens    = 20;
D_values = [0, 0.001, 0.005, 0.05, 0.5];   % cm^2/sec
finals   = zeros(size(D_values));

figure; hold on;
colors = lines(length(D_values));

for i = 1:length(D_values)
    [info, predator, prey] = lab4_default_params();
    prey.diffusion = D_values(i);
    [t, m, s, ~] = lab4_ensemble(info, predator, prey, n_ens);
    plot(t, m, 'LineWidth', 2, 'Color', colors(i,:), ...
         'DisplayName', sprintf('D = %.3f  (final = %.1f \\pm %.1f)', ...
                                D_values(i), m(end), s(end)));
    fill([t fliplr(t)], [m+s fliplr(m-s)], colors(i,:), ...
         'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
    finals(i) = m(end);
    fprintf('D = %.3f : final eaten = %.2f +/- %.2f\n', D_values(i), m(end), s(end));
end

xlabel('time (s)'); ylabel('cumulative prey eaten');
title('Exercise 1c: effect of prey diffusion coefficient');
legend('Location', 'northwest'); grid on;
