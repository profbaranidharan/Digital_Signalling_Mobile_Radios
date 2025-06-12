clc;
clear;
close all;

%% Parameters
M = 16;                         % Modulation order (e.g., 16-QAM)
k = log2(M);                    % Bits per symbol
numBits = 300;                  % Number of bits
numSymbols = numBits / k;

Fs = 10000;                     % Sampling frequency
fc = 1000;                      % Carrier frequency (Hz)
T = 1e-3;                       % Symbol duration
Ns = T * Fs;                    % Samples per symbol

%% Generate random bits and symbols
msgBits = randi([0 1], numBits, 1);
msgSym = bi2de(reshape(msgBits, k, []).', 'left-msb');

%% QAM Modulation
modSym = qammod(msgSym, M, 'gray');      % QAM symbols with Gray coding

%% Time vector for 5 symbols
L = 5;
t = 0:1/Fs:(L*T - 1/Fs);

% Upsample modulated signal
modSig_upsampled = repelem(modSym(1:L), Ns);

% Carrier signal
carrier = cos(2*pi*fc*t);

% Modulated waveform (real passband signal)
qam_waveform = real(modSig_upsampled .* exp(1j*2*pi*fc*t));

% Message waveform for plotting (shorter segment)
bitWave = repelem(msgBits(1:50), Fs*1e-4);  % Show 50 bits
t_bit = (0:length(bitWave)-1) / Fs;

%% Plotting
figure('Color','w');

subplot(3,1,1);
plot(t_bit, bitWave, 'r', 'LineWidth', 1.5);
xlabel('\bfTime (s)'); ylabel('\bfAmplitude');
title('\bfMessage Signal (Bits)');
xlim([0, t_bit(end)]);
grid on;

subplot(3,1,2);
plot(t, carrier, 'g', 'LineWidth', 1.5);
xlabel('\bfTime (s)'); ylabel('\bfAmplitude');
title('\bfCarrier Signal');
grid on;

subplot(3,1,3);
plot(t, qam_waveform, 'b', 'LineWidth', 1.5);
xlabel('\bfTime (s)'); ylabel('\bfAmplitude');
title(sprintf('\\bf%d-QAM Modulated Signal', M));
grid on;

print('qam_plot01', '-depsc');

figure;
plot(real(modSym), imag(modSym), 'mo', 'LineWidth', 1.5);
xlabel('\bfIn-Phase'); ylabel('\bfQuadrature');
title(sprintf('\\bf%d-QAM Constellation Diagram', M));
axis equal; grid on;

%% Save figure as EPS
print('qam_plot02', '-depsc');   % Save as 'qam_plot.eps'
