% Parameters
fc = 5;               % Carrier frequency (Hz)
Tb = 1;               % Symbol duration (seconds) (2 bits per symbol)
Fs = 1000;            % Sampling frequency (Hz)
t_sym = 0:1/Fs:Tb-1/Fs;

% Message bits (example sequence, length multiple of 2)
bits = [0 1 1 1 0 0 1 0];

% Check bits length is even
if mod(length(bits),2) ~= 0
    error('Number of bits must be even for QPSK');
end

% Map bits to symbols (Gray coding)
% 00 ->  1 + j1
% 01 -> -1 + j1
% 11 -> -1 - j1
% 10 ->  1 - j1
bit_pairs = reshape(bits, 2, [])';

% Pre-allocate symbol array
symbols = zeros(size(bit_pairs,1),1);

% Map bit pairs to complex symbols
for k = 1:size(bit_pairs,1)
    b1 = bit_pairs(k,1);
    b2 = bit_pairs(k,2);
    if b1==0 && b2==0
        symbols(k) = 1 + 1j;
    elseif b1==0 && b2==1
        symbols(k) = -1 + 1j;
    elseif b1==1 && b2==1
        symbols(k) = -1 - 1j;
    elseif b1==1 && b2==0
        symbols(k) = 1 - 1j;
    end
end

% Normalize symbol energy to 1 (optional)
symbols = symbols / sqrt(2);

% Generate carriers
carrier_I = cos(2*pi*fc*t_sym);         % In-phase carrier
carrier_Q = sin(2*pi*fc*t_sym);         % Quadrature carrier

% Generate QPSK modulated signal
qpsk_signal = [];
for k = 1:length(symbols)
    s = real(symbols(k))*carrier_I - imag(symbols(k))*carrier_Q; 
    qpsk_signal = [qpsk_signal s];
end

% Time vector for full signal
t = 0:1/Fs:Tb*length(symbols)-1/Fs;

% --- Plotting ---

figure;

% Plot bits as steps
subplot(4,1,1)
stairs(0:length(bits), [bits bits(end)], 'LineWidth', 2, 'Color', [0 0.4470 0.7410]) % blue
ylim([-0.5 1.5])
title('Message Bits')
xlabel('Bit index')
ylabel('Bit value')
grid on

% Plot carriers (first symbol duration only)
subplot(4,1,2)
plot(t_sym, carrier_I, 'b', 'LineWidth', 2)
hold on
plot(t_sym, carrier_Q, 'r', 'LineWidth', 2)
hold off
legend('Carrier I','Carrier Q')
title('Carrier Signals (one symbol duration)')
xlabel('Time (s)')
ylabel('Amplitude')
grid on
xlim([0 Tb])

% Plot QPSK modulated signal (received)
subplot(4,1,3)
plot(t, qpsk_signal, 'm', 'LineWidth', 2) % magenta
title('QPSK Modulated Signal (Received)')
xlabel('Time (s)')
ylabel('Amplitude')
grid on
xlim([0 Tb*length(symbols)])

% Plot constellation diagram
subplot(4,1,4)
plot(real(symbols), imag(symbols), 'ro', 'MarkerSize', 10, 'LineWidth', 2)
xlim([-1.5 1.5])
ylim([-1.5 1.5])
grid on
title('QPSK Constellation Diagram')
xlabel('In-phase')
ylabel('Quadrature')

% Save figure as EPS file
print('-depsc2','qpsk_modulation.eps')
