clc;
clear;

% Step 1: Load the audio file
[fileName, filePath] = uigetfile('*.mp3', 'Select an MP3 file');
if isequal(fileName, 0)
    disp('No file selected. Exiting...');
    return;
end

[song, Fs] = audioread(fullfile(filePath, fileName)); % Load the song
song = mean(song, 2); % Convert to mono by averaging stereo channels
song = song / max(abs(song)); % Normalize the audio signal

% Step 2: Define parameters
Fc = 40000; % Carrier frequency (40 kHz)
t = (0:length(song)-1) / Fs; % Time vector for the entire audio file

% Step 3: Generate 40 kHz carrier wave (square wave with 50% duty cycle)
carrier = square(2 * pi * Fc * t, 50); % Square wave, 50% duty cycle

% Step 4: Perform amplitude modulation
modulatedSignal = (1 + song') .* carrier; % AM modulation

% Step 5: Plot results
figure;

% Plot the original audio signal for the first 0.5 seconds for clarity
subplot(3, 1, 1);
plot(t(1:Fs*10), song(1:Fs*10)); % First 0.5 seconds of the audio
title('Original Audio Signal (First 0.5 seconds)');
xlabel('Time (s)');
ylabel('Amplitude');
axis([0 10 -1 1])

% Plot the carrier signal for the first 0.5 seconds
subplot(3, 1, 2);
plot(t(1:Fs*10), carrier(1:Fs*10));
title('40 kHz Carrier Signal (First 0.5 seconds)');
xlabel('Time (s)');
ylabel('Amplitude');
axis([0 10 -2 2])

% Plot the modulated signal for the first 0.5 seconds
subplot(3, 1, 3);
plot(t(1:Fs*10), modulatedSignal(1:Fs*10));
title('Amplitude Modulated Signal (First 0.5 seconds)');
xlabel('Time (s)');
ylabel('Amplitude');
axis([0 10 -2 2])

% Step 6: Save the modulated signal as a WAV file
outputFileName = fullfile(filePath, 'modulated_signal.wav');
audiowrite(outputFileName, modulatedSignal, Fs);
disp(['Modulated signal saved to: ' outputFileName]);
