% Parameters
fc = 5;             % Carrier frequency (Hz)
Tb = 1;             % Bit duration (s)
Fs = 1000;          % Sampling frequency (Hz)
t_bit = 0:1/Fs:Tb-1/Fs;

% Message bits (example sequence)
bits = [1 0 1 1 0 0 1];

% Map bits: 1 -> +1, 0 -> -1
symbols = 2*bits - 1;

% Generate carrier signal for entire bit sequence
carrier_signal = [];
for k = 1:length(symbols)
    carrier_signal = [carrier_signal cos(2*pi*fc*t_bit)];
end

% Generate BPSK signal for entire bit sequence
bpsk_signal = [];
for k = 1:length(symbols)
    s = symbols(k) * cos(2*pi*fc*t_bit);
    bpsk_signal = [bpsk_signal s];
end

% Time vector for full signal
t = 0:1/Fs:Tb*length(symbols)-1/Fs;

% --- Plotting ---

figure;

% Plot bits as steps
subplot(4,1,1)
stairs([0:length(bits)], [bits bits(end)], 'LineWidth', 2, 'Color', [0 0.4470 0.7410]) % blue
ylim([-0.5 1.5])
title('Message Bits')
xlabel('Bit index')
ylabel('Bit value')
grid on

% Plot carrier signal
subplot(4,1,2)
plot(t, carrier_signal, 'k', 'LineWidth', 2) % black
title('Carrier Signal')
xlabel('Time (s)')
ylabel('Amplitude')
grid on
xlim([0 Tb*length(bits)])

% Plot BPSK modulated signal (received)
subplot(4,1,3)
plot(t, bpsk_signal, 'r', 'LineWidth', 2) % red
title('BPSK Modulated Signal (Received)')
xlabel('Time (s)')
ylabel('Amplitude')
grid on
xlim([0 Tb*length(bits)])

% Plot constellation diagram (symbols on I axis)
subplot(4,1,4)
plot(symbols, zeros(size(symbols)), 'mo', 'MarkerSize', 10, 'LineWidth', 2) % magenta circles
xlim([-2 2])
ylim([-1 1])
grid on
title('BPSK Constellation Diagram')
xlabel('In-phase')
ylabel('Quadrature')
yticks([]) % hide y-axis ticks since Q=0

% Save figure as EPS file
print('-depsc2','bpsk_modulation.eps')
