clc; clear;

[filepath, bands, out_fs] = user_input();

[x, fs] = audioread(filepath);
x = mean(x, 2);
input_signal = struct('x', x, 'fs', fs);
if out_fs == 0
    out_fs = fs;
end

filtered_bands = filtering(bands, input_signal);

composite = sum(filtered_bands, 2);


% Drawing Time Domain Signal
t = (0:length(x)-1) / fs;  % time vector in seconds

figure;
subplot(2,1,1);
plot(t, x);
title('Original Signal (Time Domain)');
xlabel('Time (seconds)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, composite);
title('Composite Signal (Time Domain)');
xlabel('Time (seconds)');
ylabel('Amplitude');

% Drawing Frequency Domain Signal
N = length(x);
f = (0:N-1)*(fs/N);  % frequency vector

X = abs(fft(x));          % FFT magnitude of original
Composite_FFT = abs(fft(composite));  % FFT magnitude of composite

figure;
subplot(2,1,1);
plot(f(1:floor(N/2)), X(1:floor(N/2)));
title('Original Signal (Frequency Domain)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2,1,2);
plot(f(1:floor(N/2)), Composite_FFT(1:floor(N/2)));
title('Composite Signal (Frequency Domain)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Playing Sound
composite = composite / max(abs(composite));
sound(composite, out_fs);
audiowrite('output_equalized.wav', composite, out_fs);
audiowrite('output_equalized_four.wav', composite, out_fs * 4);
audiowrite('output_equalized_half.wav', composite, out_fs * 0.5);

