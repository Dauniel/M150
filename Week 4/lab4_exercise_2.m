% lab4_exercise_2.m
% Exercise 2: How does handling_time change consumption?
% Also: in the handling-time-limited regime (k=1, f=1, large Th),
% does the simulation match the predicted Holling Type II form
%       rate = b N / (1 + a N)         with b/a = 1/Th  ?

clear; clc;
n_ens = 20;

% ---------- Part 1: default vs handling_time = 0.5 ----------
[info, predator, prey] = lab4_default_params();
[t_a, m_a, s_a, ~] = lab4_ensemble(info, predator, prey, n_ens);

[info, predator, prey] = lab4_default_params();
predator.handling_time = 0.5;
[t_b, m_b, s_b, ~] = lab4_ensemble(info, predator, prey, n_ens);

figure;
subplot(1,2,1); hold on;
plot(t_a, m_a, 'LineWidth', 2, 'DisplayName', sprintf('T_h = 0   (final = %.1f)', m_a(end)));
fill([t_a fliplr(t_a)], [m_a+s_a fliplr(m_a-s_a)], [0 0.4 0.8], ...
     'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
plot(t_b, m_b, 'LineWidth', 2, 'DisplayName', sprintf('T_h = 0.5 s  (final = %.1f)', m_b(end)));
fill([t_b fliplr(t_b)], [m_b+s_b fliplr(m_b-s_b)], [0.85 0.4 0.1], ...
     'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
xlabel('time (s)'); ylabel('cumulative prey eaten');
title('Ex 2: handling time comparison');
legend('Location', 'northwest'); grid on;
fprintf('Th=0   : %.2f\n', m_a(end));
fprintf('Th=0.5 : %.2f\n', m_b(end));

% ---------- Part 2: Holling type II — vary density, k=f=1, Th=0.5 ----------
densities = [1, 2, 5, 10, 25, 50];
Th        = 0.5;
rates     = zeros(size(densities));
rate_stds = zeros(size(densities));

fprintf('\nHandling-time-limited regime (k=1, f=1, Th=%.1f):\n', Th);
for i = 1:length(densities)
    [info, predator, prey] = lab4_default_params();
    info.prey_density       = densities(i);
    info.tf                 = 120;
    predator.handling_time  = Th;
    predator.k              = 1.0;
    predator.f              = 1.0;
    prey.num      = info.prey_density * info.maxX * info.maxY;
    prey.pos      = rand(prey.num, 2);
    prey.pos(:,1) = prey.pos(:,1) * info.maxX;
    prey.pos(:,2) = prey.pos(:,2) * info.maxY;

    n_ens_i = 10;     % heavier sims, fewer reps
    [t, m, s, ~] = lab4_ensemble(info, predator, prey, n_ens_i);
    rates(i)     = m(end) / t(end);
    rate_stds(i) = s(end) / t(end);
    fprintf('  N=%3d : rate = %.3f +/- %.3f prey/s   (1/Th = %.2f)\n', ...
            densities(i), rates(i), rate_stds(i), 1/Th);
end

% Fit Holling II with the constraint b/a = 1/Th
holling = @(p, N) p(1) * N ./ (1 + p(1)*Th .* N);  % b=p(1), a = b*Th
b_fit   = lsqcurvefit(holling, 0.5, densities, rates);
a_fit   = b_fit * Th;

subplot(1,2,2); hold on;
errorbar(densities, rates, rate_stds, 'o', 'MarkerSize', 8, 'LineWidth', 1.5, ...
         'DisplayName', 'simulation');
N_smooth = linspace(0.1, max(densities), 200);
plot(N_smooth, holling(b_fit, N_smooth), 'r-', 'LineWidth', 2, ...
     'DisplayName', sprintf('Holling II fit: b=%.2f, a=%.2f', b_fit, a_fit));
yline(1/Th, ':', sprintf('1/T_h = %.1f', 1/Th), 'LineWidth', 1.5);
xlabel('prey density N'); ylabel('consumption rate (prey/s)');
title('Holling Type II response (T_h=0.5, k=f=1)');
legend('Location', 'southeast'); grid on;

fprintf('\nFit: b = %.3f, a = %.3f, b/a = %.3f  (predicted 1/Th = %.3f)\n', ...
        b_fit, a_fit, b_fit/a_fit, 1/Th);
