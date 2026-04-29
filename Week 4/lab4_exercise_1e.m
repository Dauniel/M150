% lab4_exercise_1e.m
% Exercise 1e: With info.replenish_prey = 0, how does consumption
% change over time? (Run for a long time so depletion is visible -
% with default params only ~30 prey out of 1000 are eaten in 50 s,
% so depletion is not yet visible at t_f = 50.)

clear; clc;
n_ens = 8;
tf_long = 1500;     % long enough to see saturation

% Run WITH replenishment for comparison
[info, predator, prey] = lab4_default_params();
info.tf = tf_long;
[t1, m1, s1, ~] = lab4_ensemble(info, predator, prey, n_ens);

% Run WITHOUT replenishment
[info, predator, prey] = lab4_default_params();
info.tf             = tf_long;
info.replenish_prey = 0;
[t2, m2, s2, ~] = lab4_ensemble(info, predator, prey, n_ens);

figure; hold on;
plot(t1, m1, 'LineWidth', 2, 'DisplayName', ...
     sprintf('replenish = 1  (final = %.0f)', m1(end)));
fill([t1 fliplr(t1)], [m1+s1 fliplr(m1-s1)], [0 0.4 0.8], ...
     'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
plot(t2, m2, 'LineWidth', 2, 'DisplayName', ...
     sprintf('replenish = 0  (final = %.0f)', m2(end)));
fill([t2 fliplr(t2)], [m2+s2 fliplr(m2-s2)], [0.85 0.4 0.1], ...
     'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
yline(prey.num, ':', 'total prey', 'LineWidth', 1.5);
xlabel('time (s)'); ylabel('cumulative prey eaten');
title('Exercise 1e: replenishment on vs off');
legend('Location', 'southeast'); grid on;

% Quantitative comparison: rate during early vs late windows
rate = @(t, m, t0, t1) ...
    (m(find(t >= t1, 1)) - m(find(t >= t0, 1))) / (t1 - t0);

fprintf('Replenish ON  - rate (prey/s): early = %.3f, late = %.3f\n', ...
        rate(t1, m1, 0, 100), rate(t1, m1, 1400, 1500));
fprintf('Replenish OFF - rate (prey/s): early = %.3f, late = %.3f\n', ...
        rate(t2, m2, 0, 100), rate(t2, m2, 1400, 1500));
