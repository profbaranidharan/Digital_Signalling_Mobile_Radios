clc;
clear;
close all;

%% Parameters
M = 8;                        % Modulation order (M-PSK)
k = log2(M);                  % Bits per symbol
numBits = 300;                % Number of message bits
numSymbols = numBits / k;

Fs = 10000;                   % Sampling frequency
fc = 1000;                    % Carrier frequency
T = 1e-3;                     % Symbol duration
Ns = T * Fs;                  % Samples per symbol

%% Generate random message bits and symbols
msgBits = randi([0 1], numBits, 1);
msgSym = bi2de(reshape(msgBits, k, []).', 'left-msb');

%% PSK Modulation
modSym = pskmod(msgSym, M, pi/M);   % Modulated symbols (complex baseband)

%% Time vector for 5 symbols
L = 5;
t = 0:1/Fs:(L*T - 1/Fs);

% Repeat each symbol for Ns samples
modSig_upsampled = repelem(modSym(1:L), Ns);

% Carrier signal
carrier = cos(2*pi*fc*t);

% Message waveform (bit stream upsampled)
bitWave = repelem(msgBits(1:50), Fs*1e-4);  % shorter bit segment for clarity
t_bit = (0:length(bitWave)-1) / Fs;

% Modulated signal (real part)
psk_waveform = real(modSig_upsampled .* exp(1j*2*pi*fc*t));

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
plot(t, psk_waveform, 'b', 'LineWidth', 1.5);
xlabel('\bfTime (s)'); ylabel('\bfAmplitude');
title(sprintf('\\bf%d-PSK Modulated Signal', M));
grid on;

print('mpsk01', '-depsc');  % Saves as 'e.eps'

figure;
plot(real(modSym), imag(modSym), 'mo', 'LineWidth', 1.5);
xlabel('\bfIn-Phase'); ylabel('\bfQuadrature');
title(sprintf('\\bf%d-PSK Constellation Diagram', M));
axis equal; grid on;

%% Save the figure
print('mpsk02', '-depsc');  % Saves as 'e.eps'
