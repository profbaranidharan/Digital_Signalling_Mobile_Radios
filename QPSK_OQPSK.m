clc; clear; close all;

%% Parameters
numSymbols = 100;         % Number of symbols
M = 4;                    % QPSK
sps = 8;                  % Samples per symbol
beta = 0.35;              % Roll-off factor for raised cosine
span = 10;                % Filter span in symbols
lineWidth = 1.5;          % Line width for visibility in EPS

%% Generate random QPSK symbols
data = randi([0 M-1], numSymbols, 1);
qpskSymbols = pskmod(data, M, pi/4);  % QPSK with pi/4 rotation

%% Create Raised Cosine Filter
rcFilter = rcosdesign(beta, span, sps, 'sqrt');

%% QPSK: Upsample and filter
qpskUpsampled = upsample(qpskSymbols, sps);
qpskFiltered = conv(qpskUpsampled, rcFilter, 'same');

%% OQPSK Signal Generation
I = real(qpskSymbols);
Q = imag(qpskSymbols);

I_up = upsample(I, sps);
Q_up = upsample(Q, sps);
Q_up = [zeros(sps/2,1); Q_up(1:end - sps/2)];

oqpskSignal = I_up + 1j * Q_up;
oqpskFiltered = conv(oqpskSignal, rcFilter, 'same');

%% Plot
figure('Color','w');
tiledlayout(1,2,'Padding','compact','TileSpacing','compact');

% QPSK
nexttile
plot(real(qpskFiltered), imag(qpskFiltered), 'b', 'LineWidth', lineWidth);
title('QPSK with Pulse Shaping');
xlabel('In-Phase'); ylabel('Quadrature'); grid on;
axis equal;
set(gca, 'FontSize', 11);

% OQPSK
nexttile
plot(real(oqpskFiltered), imag(oqpskFiltered), 'r', 'LineWidth', lineWidth);
title('OQPSK with Pulse Shaping');
xlabel('In-Phase'); ylabel('Quadrature'); grid on;
axis equal;
set(gca, 'FontSize', 11);

sgtitle('Baseband Trajectories: QPSK vs OQPSK', 'FontSize', 11);

%% Save as EPS
print('-depsc2','-r300','qpsk_vs_oqpsk.eps');
