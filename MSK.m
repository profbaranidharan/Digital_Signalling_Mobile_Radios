% Parameters
Rb = 1e3;              % Bit rate (bits/s)
Tb = 1/Rb;             % Bit duration (s)
Fs = 100*Rb;           % Sampling frequency (samples/s) - increased for smoothness
Ts = 1/Fs;             % Sampling interval
Nbits = 20;            % Number of bits (reduced for clearer plots)
fc = 5e3;              % Carrier frequency (Hz)

% Generate random bipolar bits (+1/-1)
data = 2*randi([0 1],1,Nbits) - 1;

% Time vector for one bit duration
t_bit = 0:Ts:Tb-Ts;

% Create message signal as rectangular pulses (bipolar NRZ)
msg_signal = zeros(1, Nbits*length(t_bit));
for k = 1:Nbits
    idx = (k-1)*length(t_bit) + (1:length(t_bit));
    msg_signal(idx) = data(k);
end
t_msg = 0:Ts:Tb*Nbits - Ts;

% Separate odd and even bits (I and Q streams)
I_bits = data(1:2:end);
Q_bits = data(2:2:end);

% Half-sinusoidal pulse shaping function p(t)
t_pulse = 0:Ts:2*Tb - Ts;
p = sin(pi*t_pulse/(2*Tb));

% Prepare baseband signals for I and Q with zero padding for offset
I_signal = zeros(1, length(t_pulse)*length(I_bits));
Q_signal = zeros(1, length(t_pulse)*length(Q_bits) + length(t_pulse)/2);

% Generate I stream shaped pulses spaced by 2Tb
for k = 1:length(I_bits)
    idx = (k-1)*length(t_pulse) + (1:length(t_pulse));
    I_signal(idx) = I_bits(k) * p;
end

% Generate Q stream shaped pulses spaced by 2Tb, offset by Tb (half pulse)
offset = length(t_pulse)/2;
for k = 1:length(Q_bits)
    idx = offset + (k-1)*length(t_pulse) + (1:length(t_pulse));
    Q_signal(idx) = Q_bits(k) * p;
end

% Make signals equal length by zero-padding
len = max(length(I_signal), length(Q_signal));
I_signal(len) = 0;
Q_signal(len) = 0;

% Time vector for entire signal
t = (0:len-1)*Ts;

% Carrier signals (cos and sin)
carrier_cos = cos(2*pi*fc*t);
carrier_sin = sin(2*pi*fc*t);

% MSK signal
s = I_signal .* carrier_cos + Q_signal .* carrier_sin;

% Plotting
figure('Position',[100 100 900 700]);

% Plot message bits as rectangular pulses
subplot(3,1,1);
plot(t_msg*1e3, msg_signal, 'LineWidth', 2, 'Color', [0 0.4470 0.7410]); % blue
ylim([-1.5 1.5]);
title('Message Bits (Bipolar NRZ)', 'FontWeight','bold');
xlabel('Time (ms)', 'FontWeight','bold');
ylabel('Amplitude', 'FontWeight','bold');
grid on;
set(gca,'FontWeight','bold','FontSize',12);

% Plot carriers (zoomed over 2 ms)
subplot(3,1,2);
hold on;
plot(t(1:round(2e-3*Fs))*1e3, carrier_cos(1:round(2e-3*Fs)), 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980]); % orange
plot(t(1:round(2e-3*Fs))*1e3, carrier_sin(1:round(2e-3*Fs)), 'LineWidth', 2, 'Color', [0.9290 0.6940 0.1250]); % yellow
hold off;
title('Carrier Signals', 'FontWeight','bold');
xlabel('Time (ms)', 'FontWeight','bold');
ylabel('Amplitude', 'FontWeight','bold');
legend({'cos(2\pi f_c t)', 'sin(2\pi f_c t)'}, 'FontWeight','bold');
grid on;
set(gca,'FontWeight','bold','FontSize',12);

% Plot MSK modulated signal (zoomed over 4 ms)
subplot(3,1,3);
plot(t(1:round(4e-3*Fs))*1e3, s(1:round(4e-3*Fs)), 'LineWidth', 2, 'Color', [0.4940 0.1840 0.5560]); % purple
title('MSK Modulated Signal', 'FontWeight','bold');
xlabel('Time (ms)', 'FontWeight','bold');
ylabel('Amplitude', 'FontWeight','bold');
grid on;
set(gca,'FontWeight','bold','FontSize',12);

print(gcf,'MSK_plot01','-depsc');

% Plot constellation diagram (I vs Q symbols)
symbol_points = [I_bits(:), Q_bits(:)];
figure;
plot(symbol_points(:,1), symbol_points(:,2), 'bo', 'MarkerSize', 10, 'LineWidth', 2);
title('MSK Constellation Diagram (I/Q Symbols)', 'FontWeight','bold');
xlabel('In-phase (I)', 'FontWeight','bold');
ylabel('Quadrature (Q)', 'FontWeight','bold');
axis([-1.5 1.5 -1.5 1.5]);
grid on;
set(gca,'FontWeight','bold','FontSize',12);

% Save figure as EPS
print(gcf,'MSK_plot02','-depsc');
