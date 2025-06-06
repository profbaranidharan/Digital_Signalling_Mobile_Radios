clc; clear; close all;

% Define the differential phase shifts for QPSK (pi/4 increments)
delta_theta = [-3*pi/4, -pi/4, pi/4, 3*pi/4];

% Visualization settings
markerSize = 8;
lineWidth = 2;

figure('Color', 'w');

% (a) ek when ek_1 = pi/4
prev_phase_a = pi/4;
ek_a = exp(1j * (prev_phase_a + delta_theta));
ek_a_closed = [ek_a, ek_a(1)];  % Close the loop by adding first point at the end

subplot(1, 3, 1);
plot(real(ek_a_closed), imag(ek_a_closed), 'o-', ...
    'MarkerFaceColor', [0.8 0.1 0.1], 'MarkerEdgeColor', 'k', ...
    'MarkerSize', markerSize, 'LineWidth', lineWidth, 'Color', [0.8 0.1 0.1]);
title('\theta_k when \theta_{k-1} = \pi/4', 'FontWeight', 'bold');
xlabel('In-phase'); ylabel('Quadrature');
axis equal; grid on; xlim([-1.5 1.5]); ylim([-1.5 1.5]);

% (b) ek when ek_1 = pi/2
prev_phase_b = pi/2;
ek_b = exp(1j * (prev_phase_b + delta_theta));
ek_b_closed = [ek_b, ek_b(1)];  % Close the loop

subplot(1, 3, 2);
plot(real(ek_b_closed), imag(ek_b_closed), 's-', ...
    'MarkerFaceColor', [0.1 0.6 0.1], 'MarkerEdgeColor', 'k', ...
    'MarkerSize', markerSize, 'LineWidth', lineWidth, 'Color', [0.1 0.6 0.1]);
title('\theta_k when \theta_{k-1} = \pi/2', 'FontWeight', 'bold');
xlabel('In-phase'); ylabel('Quadrature');
axis equal; grid on; xlim([-1.5 1.5]); ylim([-1.5 1.5]);

% (c) All possible states - grouped by previous phase, each closed loop separately
prev_phases = [0, pi/4, pi/2, 3*pi/4, pi, -pi/4, -pi/2, -3*pi/4];

subplot(1, 3, 3);
hold on;
colors = lines(length(prev_phases));  % distinct colors for each loop

for k = 1:length(prev_phases)
    points = exp(1j * (prev_phases(k) + delta_theta));
    points_closed = [points, points(1)];  % close loop
    plot(real(points_closed), imag(points_closed), 'd-', ...
        'MarkerFaceColor', colors(k,:), 'MarkerEdgeColor', 'k', ...
        'MarkerSize', markerSize, 'LineWidth', lineWidth, 'Color', colors(k,:));
end
hold off;

title('All Possible States', 'FontWeight', 'bold');
xlabel('In-phase'); ylabel('Quadrature');
axis equal; grid on; xlim([-1.5 1.5]); ylim([-1.5 1.5]);

% Save figure as EPS with trajectories
print(gcf, 'pi4QPSK_constellation_closed_trajectory', '-depsc', '-r300');
