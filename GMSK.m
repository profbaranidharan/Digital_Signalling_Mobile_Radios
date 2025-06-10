% Parameters
Rb = 1e3;              % Bit rate (bits/s)
Tb = 1/Rb;             % Bit duration (s)
Fs = 100*Rb;           % Sampling frequency (samples/s)
Ts = 1/Fs;             % Sampling interval
Nbits = 20;            % Number of bits
fc = 5e3;              % Carrier frequency (Hz)
BT = 0.3;              % Gaussian filter bandwidth-bit product (typical 0.3~0.5)

% Generate random bipolar bits (+1/-1)
data = 2*randi([0 1],1,Nbits) - 1;

% Time vector for bits
t_msg = 0:Ts:Tb*Nbits - Ts;

% Generate NRZ message signal (rectangular pulses)
msg_signal = zeros(1, length(t_msg));
for k = 1:Nbits
    idx = (k-1)*round(Tb*Fs) + (1:round(Tb*Fs));
    msg_signal(idx) = data(k);
end

% Gaussian filter design (baseband pulse shaping)
BT_product = BT;
alpha = sqrt(log(2)) / (BT_product * Tb);
t_g = (-4*Tb : Ts : 4*Tb); % filter length ~8 bit periods
h = (alpha/sqrt(pi)) * exp(- (alpha^2) * (t_g.^2)); % Gaussian impulse response
h = h / sum(h); % Normalize filter energy

% Filter the NRZ data to get smoothed phase shaping
data_upsampled = repelem(data, round(Tb*Fs)); % Upsample by bit samples
phase_shaped = conv(data_upsampled, h, 'same') * pi/2; % phase deviation, normalized by pi/2

% Integrate phase to get continuous phase signal
phase_signal = cumsum(phase_shaped) * Ts;

% Generate GMSK signal (constant envelope)
s = cos(2*pi*fc*t_msg + phase_signal);

% Carrier signals for reference (cos and sin)
carrier_cos = cos(2*pi*fc*t_msg);
carrier_sin = sin(2*pi*fc*t_msg);

% Constellation points approximation: sample filtered data at bit centers
sample_points = round((1:Nbits)*Tb*Fs - Tb*Fs/2);
I_samples = cos(phase_signal(sample_points));
Q_samples = sin(phase_signal(sample_points));

% Plotting
figure('Position',[100 100 900 700]);

% Message bits (NRZ)
subplot(3,1,1);
plot(t_msg*1e3, msg_signal, 'LineWidth', 2, 'Color', [0 0.4470 0.7410]); % blue
ylim([-1.5 1.5]);
title('Message Bits (Bipolar NRZ)', 'FontWeight','bold');
xlabel('Time (ms)', 'FontWeight','bold');
ylabel('Amplitude', 'FontWeight','bold');
grid on;
set(gca,'FontWeight','bold','FontSize',12);

% Gaussian filter impulse response
subplot(3,1,2);
plot(t_g*1e3, h, 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980]); % orange
title('Gaussian Pulse Shaping Filter Impulse Response', 'FontWeight','bold');
xlabel('Time (ms)', 'FontWeight','bold');
ylabel('Amplitude', 'FontWeight','bold');
grid on;
set(gca,'FontWeight','bold','FontSize',12);

% GMSK modulated signal (zoomed)
subplot(3,1,3);
plot(t_msg(1:round(4e-3*Fs))*1e3, s(1:round(4e-3*Fs)), 'LineWidth', 2, 'Color', [0.4940 0.1840 0.5560]); % purple
title('GMSK Modulated Signal', 'FontWeight','bold');
xlabel('Time (ms)', 'FontWeight','bold');
ylabel('Amplitude', 'FontWeight','bold');
grid on;
set(gca,'FontWeight','bold','FontSize',12);
print(gcf,'GMSK_plot01','-depsc');

% Approximate constellation diagram (I vs Q samples)
figure;
plot(I_samples, Q_samples, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
title('GMSK Approximate Constellation Diagram', 'FontWeight','bold');
xlabel('In-phase (I)', 'FontWeight','bold');
ylabel('Quadrature (Q)', 'FontWeight','bold');
axis equal;
axis([-1.2 1.2 -1.2 1.2]);
grid on;
set(gca,'FontWeight','bold','FontSize',12);

% Save figure as EPS
print(gcf,'GMSK_plot02','-depsc');
