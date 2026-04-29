% lab4_exercise_1d.m
% Exercise 1d: How does changing prey density change consumption?
% (Don't increase past ~50 to keep things tractable.)

     clear; clc;
     n_ens    = 20;
     N_values = [1, 5, 10, 25, 50];
     finals   = zeros(size(N_values));
     finals_std = zeros(size(N_values));

     figure;
     % Left panel: cumulative-eaten curves
     subplot(1,2,1); hold on;
     colors = lines(length(N_values));

     for i = 1:length(N_values)
     [info, predator, prey] = lab4_default_params();
     info.prey_density = N_values(i);
     % rebuild prey from new density
     prey.num      = info.prey_density * info.maxX * info.maxY;
     prey.pos      = rand(prey.num, 2);
     prey.pos(:,1) = prey.pos(:,1) * info.maxX;
     prey.pos(:,2) = prey.pos(:,2) * info.maxY;

     [t, m, s, ~] = lab4_ensemble(info, predator, prey, n_ens);
     plot(t, m, 'LineWidth', 2, 'Color', colors(i,:), ...
          'DisplayName', sprintf('N = %d  (final = %.1f \\pm %.1f)', ...
                                   N_values(i), m(end), s(end)));
     fill([t fliplr(t)], [m+s fliplr(m-s)], colors(i,:), ...
          'FaceAlpha', 0.15, 'EdgeColor', 'none', 'HandleVisibility', 'off');
     finals(i)     = m(end);
     finals_std(i) = s(end);
     fprintf('N = %2d : final eaten = %.2f +/- %.2f\n', N_values(i), m(end), s(end));
     end
     xlabel('time (s)'); ylabel('cumulative prey eaten');
     title('1d: cumulative eating vs density');
     legend('Location', 'northwest'); grid on;

     % Right panel: linearity check
     subplot(1,2,2); hold on;
     errorbar(N_values, finals, finals_std, 'o', 'MarkerSize', 8, 'LineWidth', 1.5, ...
          'DisplayName', 'simulation');
     % theoretical: rate = pi r^2 f k * N, total over t_f = pi r^2 f k * N * t_f
     b_pred = pi * 1.25^2 * 0.05 * 0.3;
     plot(N_values, b_pred * N_values * 50, 'r--', 'LineWidth', 2, ...
          'DisplayName', 'theory: \pi r^2 fk \cdot N \cdot t_f');
     xlabel('prey density N (cm^{-2})'); ylabel('total prey eaten at t_f');
     title('Linearity in density'); legend('Location', 'northwest'); grid on;
