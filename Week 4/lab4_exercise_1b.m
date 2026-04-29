% lab4_exercise_1b.m
% Exercise 1b: How does changing predator velocity modify the scaling?

clear; clc;
n_ens    = 20;
v_values = [0.05, 0.1, 0.2, 0.5, 1.0];
finals   = zeros(size(v_values));

figure; hold on;
colors = lines(length(v_values));

for i = 1:length(v_values)
    [info, predator, prey] = lab4_default_params();
    predator.vel = v_values(i);
    [t, m, s, ~] = lab4_ensemble(info, predator, prey, n_ens);
    plot(t, m, 'LineWidth', 2, 'Color', colors(i,:), ...
         'DisplayName', sprintf('v = %.2f  (final = %.1f \\pm %.1f)', ...
                                v_values(i), m(end), s(end)));
    fill([t fliplr(t)], [m+s fliplr(m-s)], colors(i,:), ...
         'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
    finals(i) = m(end);
    fprintf('v = %.2f : final eaten = %.2f +/- %.2f\n', v_values(i), m(end), s(end));
end

xlabel('time (s)'); ylabel('cumulative prey eaten');
title('Exercise 1b: effect of predator velocity');
legend('Location', 'northwest'); grid on;
