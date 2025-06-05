clc; clear; close all;

% Parameters
numSymbols = 50;         % Number of symbols
Fs = 100;                % Samples per symbol (even number)
Ts = 1;                  % Symbol duration
t = linspace(0, Ts, Fs); % Time vector for 1 symbol

% Define phase mappings
angles_qpsk = [0, pi/2, pi, 3*pi/2];
angles_pi4 = [pi/4, 3*pi/4, 5*pi/4, 7*pi/4];

% Generate random bits
bits = randi([0 1], numSymbols, 2);  % Each symbol: 2 bits
symbols = 2 * bits(:,1) + bits(:,2); % Convert bit pairs to symbol indices

%% QPSK
phase_qpsk = [];
for i = 1:numSymbols
    phi = angles_qpsk(symbols(i)+1);
    phase_qpsk = [phase_qpsk, repmat(phi, 1, Fs)];
end
I_qpsk = cos(phase_qpsk);
Q_qpsk = sin(phase_qpsk);

%% OQPSK - Corrected realization with half-symbol delay and rectangular pulses
I_bits = 2 * bits(:,1) - 1;  % Map 0->-1, 1->+1
Q_bits = 2 * bits(:,2) - 1;

pulse = ones(1, Fs);  % Rectangular pulse shape

% Construct I channel (no delay)
I_oqpsk = [];
for i = 1:length(I_bits)
    I_oqpsk = [I_oqpsk, I_bits(i)*pulse];
end

% Construct Q channel (delayed by half symbol)
Q_oqpsk = [zeros(1, Fs/2)]; % half symbol delay (Fs/2 samples)
for i = 1:length(Q_bits)
    Q_oqpsk = [Q_oqpsk, Q_bits(i)*pulse];
end
Q_oqpsk = Q_oqpsk(1:length(I_oqpsk));  % Trim to same length as I

% Normalize amplitude (optional)
I_oqpsk = I_oqpsk / max(abs(I_oqpsk));
Q_oqpsk = Q_oqpsk / max(abs(Q_oqpsk));

%% π/4-QPSK
phase_pi4 = 0;
phase_vec = [];
for i = 1:numSymbols
    dphi = angles_pi4(symbols(i)+1);  % Phase increment
    phase_pi4 = mod(phase_pi4 + dphi, 2*pi);  % Keep phase bounded
    phase_vec = [phase_vec, repmat(phase_pi4, 1, Fs)];
end
I_pi4 = cos(phase_vec);
Q_pi4 = sin(phase_vec);

%% Plot Baseband Trajectories
figure('Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
plot(I_qpsk, Q_qpsk, 'LineWidth', 1.5);
title('QPSK Baseband Trajectory', 'FontSize', 11);
xlabel('In-phase (I)', 'FontSize', 11);
ylabel('Quadrature (Q)', 'FontSize', 11);
axis equal; grid on;

subplot(1, 3, 2);
plot(I_oqpsk, Q_oqpsk, 'LineWidth', 1.5);
title('OQPSK Baseband Trajectory', 'FontSize', 11);
xlabel('In-phase (I)', 'FontSize', 11);
ylabel('Quadrature (Q)', 'FontSize', 11);
axis equal; grid on;

subplot(1, 3, 3);
plot(I_pi4, Q_pi4, 'LineWidth', 1.5);
title('\pi/4-QPSK Baseband Trajectory', 'FontSize', 11);
xlabel('In-phase (I)', 'FontSize', 11);
ylabel('Quadrature (Q)', 'FontSize', 11);
axis equal; grid on;

% Save the figure as EPS
print('-depsc2', 'baseband_trajectories_comparison.eps');
