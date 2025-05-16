function [fullFilePath, bandsArray, out_fs] = user_input()
    disp("Please choose the audio file: ");
    [fileName, pathName] = uigetfile('*.wav');
    fullFilePath = fullfile(pathName, fileName);
    
    mode = take_input("Choose mode:\n1) Standard\n2) Custom\nEnter wanted mode: ", 1, 2);
    
    numOfBands = 9;

    if mode == 2
        numOfBands = take_input("Enter number of bands wanted: ", 5, 10);
    end
    
    bandsArray(numOfBands) = struct('lower', 0, 'upper', 0, 'gain', 0, 'f_type', 0, 'f_order', 0); 
    
    lowerFreqs = [0, 200, 500, 800, 1200, 3000, 6000, 12000, 16000];
    upperFreqs = [200, 500, 800, 1200, 3000, 6000, 12000, 16000, 20000];

    for index = 1:numOfBands
        fprintf('--- Band %d ---\n', index);
        if mode == 2
            lower = take_input('Enter lower frequency: ', 20, 20000);
            upper = take_input('Enter upper frequency: ', lower + 1, 22000);  % upper must be > lower
        else
            lower = lowerFreqs(index);
            upper = upperFreqs(index);
            fprintf('Frequency Range: %d - %d\n', lower, upper);
        end
        gain = take_input('Enter gain in dB: ', -12, 12);
        f_type = take_input('Enter Filter Type:\nFIR: \n1) Hamming\n2) Hanning\n3) Blackman\nIIR:\n4) ButterWorth\n5) Checbyshev I\n6) Chebyshev II\nEnter wanted filter: ', 1, 6);
        f_order = take_input("Enter filter order: ", -inf, inf);
        
        bandsArray(index) = struct( ...
            'lower', lower, ...
            'upper', upper, ...
            'gain', gain, ...
            'f_type', f_type, ...
            'f_order', f_order ...
        );
    end
    out_fs = take_input("Do you want to change output sampling rate?\n1) Yes\n2) No\nEnter Choice", 1, 2);
    if out_fs == 1 
        out_fs = take_input("Enter output sample rate: ", -inf, inf);
    else
        out_fs = 0;
    end
end