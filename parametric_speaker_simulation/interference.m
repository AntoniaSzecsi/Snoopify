% Parameters
f = 40e3; % Frequency (Hz)
c = 343; % Speed of sound (m/s)
lambda = c / f; % Wavelength (m)
phi = pi / 12; % Phase difference (15 degrees in radians)
A = 1; % Amplitude

% Grid setup
x_range = linspace(-0.2, 0.2, 500); % 40 cm range in x
y_range = linspace(0, 0.3, 500); % 30 cm range in y
[x, y] = meshgrid(x_range, y_range);

% Transmitter positions (side by side, angled inward)
tx1 = [-0.05, 0]; % Transmitter 1 (5 cm apart)
tx2 = [0.05, 0]; % Transmitter 2

% Angles for slight inward tilt
theta_inward = deg2rad(10); % 10 degrees inward tilt

% Calculate effective directional angles
tx1_angle = [sin(theta_inward), cos(theta_inward)];
tx2_angle = [-sin(theta_inward), cos(theta_inward)];

% Distance from each point to the transmitters
r1 = sqrt((x - tx1(1)).^2 + (y - tx1(2)).^2);
r2 = sqrt((x - tx2(1)).^2 + (y - tx2(2)).^2);

% Directional beam angles relative to inward tilt
theta1 = atan2(y - tx1(2), x - tx1(1)) - atan2(tx1_angle(2), tx1_angle(1));
theta2 = atan2(y - tx2(2), x - tx2(1)) - atan2(tx2_angle(2), tx2_angle(1));

% Directional masks for inward beams
beam_width = pi / 6; % 30 degrees beam width
mask1 = abs(theta1) < beam_width; % Transmitter 1 beam mask
mask2 = abs(theta2) < beam_width; % Transmitter 2 beam mask

% Generate directional signals
k = 2 * pi / lambda; % Wave number
signal1 = A * sin(k * r1) .* mask1; % Signal from transmitter 1
signal2 = A * sin(k * r2 + phi) .* mask2; % Signal from transmitter 2

% interferencevar pattern
interferencevar = signal1 + signal2;

% Highlight constructive interferencevar (intersection)
threshold = 1.5; % Adjust to emphasize strong intersections
intersection = abs(interferencevar) > threshold;

% Visualization
figure;

% Grayscale background for the interferencevar pattern
imagesc(x_range, y_range, abs(interferencevar)');
colormap('gray');
hold on;

% Overlay intersection points in color
contourf(x, y, intersection, 1, 'LineColor', 'none', 'FaceColor', 'green', 'FaceAlpha', 0.6);

% Add labels and formatting
colorbar;
xlabel('x (m)');
ylabel('y (m)');
title('Directional Ultrasound Wave Intersection (Inward Tilt)');
axis equal;
