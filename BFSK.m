clc; clear; close all;

% Parameters
bit_seq = [1 0 1 1 0 0 1];    % Input binary sequence
bit_rate = 1;                 % Bits per second
Tb = 1/bit_rate;              % Bit duration
fs = 1000;                   % Sampling frequency (samples per second)
f0 = 10;                     % Frequency for bit 0 (Hz)
f1 = 20;                     % Frequency for bit 1 (Hz)
t_bit = 0:1/fs:Tb-1/fs;       % Time vector for one bit
N = length(bit_seq);

% Generate Message Signal (step signal)
message_signal = repelem(bit_seq, length(t_bit));

% Generate Carrier Signals for one bit duration
carrier_0 = cos(2*pi*f0*t_bit);
carrier_1 = cos(2*pi*f1*t_bit);

% Generate BFSK Signal
bfsk_signal = [];
for bit = bit_seq
    if bit == 1
        bfsk_signal = [bfsk_signal cos(2*pi*f1*t_bit)];
    else
        bfsk_signal = [bfsk_signal cos(2*pi*f0*t_bit)];
    end
end

% Time vector for full signal
t_total = 0:1/fs:Tb*N-1/fs;

% --- Create figure with 4 subplots ---
figure('Position', [100 100 900 700]);

% 1) Message Signal
subplot(3,1,1);
stairs(t_total, message_signal, 'LineWidth', 2);
ylim([-0.2 1.2]);
title('Message Signal (Binary Data)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% 2) Carrier Signals
subplot(3,1,2);
plot(t_bit, carrier_0, 'b', 'LineWidth', 2);
hold on;
plot(t_bit, carrier_1, 'r', 'LineWidth', 2);
hold off;
title('Carrier Signals');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Carrier for bit 0 (f_0)', 'Carrier for bit 1 (f_1)', 'Location', 'best');
grid on;

% 3) BFSK Modulated Signal
subplot(3,1,3);
plot(t_total, bfsk_signal, 'm', 'LineWidth', 2);
title('BFSK Modulated Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
saveas(gcf, 'bfsk_plots01.eps', 'epsc');

% 4) Constellation Diagram
figure;
const_points = [];
for bit = bit_seq
    if bit == 1
        const_points = [const_points, exp(1j*2*pi*f1*Tb)];
    else
        const_points = [const_points, exp(1j*2*pi*f0*Tb)];
    end
end
plot(real(const_points), imag(const_points), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
title('BFSK Constellation Diagram');
xlabel('In-phase');
ylabel('Quadrature');
grid on;
axis equal;
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
saveas(gcf, 'bfsk_plots02.eps', 'epsc');