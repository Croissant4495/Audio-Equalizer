function [filtered_bands]= filtering(bandsArray, input_signal)

Number_of_bands = length(bandsArray);
fs = input_signal.fs;
filtered_bands = zeros(length(input_signal.x), Number_of_bands);

% Filter Type:
% 1 = FIR-Hamming
% 2 = FIR-Hanning
% 3 = FIR-Blackman
% 4 = IIR-Butterworth
% 5 = IIR-Cheby1
% 6 = IIR-Cheby2

for i = 1:Number_of_bands
    type = bandsArray(i).f_type;
    order = bandsArray(i).f_order;
    f1 = bandsArray(i).lower;
    f2 = bandsArray(i).upper;
    
    Wn = [f1, f2] / (fs/2); 

    switch type
        case 1  % FIR - Hamming
            numerator = fir1(order, Wn, 'bandpass', hamming(order + 1));
            Denominator = 1;
        case 2  % FIR - Hanning
            numerator = fir1(order, Wn, 'bandpass', hanning(order + 1));
            Denominator = 1;
        case 3  % FIR - Blackman
            numerator = fir1(order, Wn, 'bandpass', blackman(order + 1));
            Denominator = 1;
        case 4  % IIR - Butterworth
            [numerator, Denominator] = butter(order, Wn, 'bandpass');
        case 5  % IIR - Chebyshev I
            Rp = 1; 
            [numerator, Denominator] = cheby1(order, Rp, Wn, 'bandpass');
        case 6  % IIR - Chebyshev II
            Rs = 20; 
            [numerator, Denominator] = cheby2(order, Rs, Wn, 'bandpass');
    end
    [H, W] = freqz(numerator, Denominator, 1024, fs);
    magnitude = abs(H);
    phase = angle(H);
    Impulse_Response = impz(numerator, Denominator);
    Step_Response = stepz(numerator, Denominator); 
    figure;
    subplot(2,2,1);
    plot(W, magnitude);
    title('Magnitude Response');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    %%%%%%%%%
    subplot(2,2,2);
    plot(W, phase*180/pi);
    title('Phase Response');
    xlabel('Frequency (Hz)');
    ylabel('Phase (degree)');
    %%%%%%%%%%%%
    subplot(2,2,3);
    stem(Impulse_Response);
    title('Impulse Response');
    xlabel('Samples');
    ylabel('Amplitude');
    %%%%%%%%%%%
    subplot(2,2,4); 
    stem(Step_Response); 
    title('Step Response');
    xlabel('Samples');
    ylabel('Amplitude');
    filtered_signal = bandsArray(i).gain * filter(numerator, Denominator, input_signal.x);

    filtered_bands(:, i) = filtered_signal;
end
end