% Heart rate data
heartRateData = [158, 152, 147, 142, 139, 135, 131, 127, 119, 115, 114, 110, 111, 108, 110, 105, 99, 99, 96, 92, 94, 92, 92, 94];

% Time vector
time = (0:10:(length(heartRateData)-1)*10)';

% Plot the data
plot(time, heartRateData, 'o');
xlabel('Time (seconds)');
ylabel('Heart Rate');
title('Heart Rate Data');
grid on;

% Identify transfer function
sys = tfest(iddata(heartRateData', time, 10), 2, 1);

% Display transfer function parameters
disp('Transfer Function Parameters:');
disp(sys);

% Simulink model
open_system('new_model', 'force');

% Update transfer function block parameters in Simulink model
block = 'new_model/Transfer Function';
set_param(block, 'Numerator', mat2str(sys.Numerator));
set_param(block, 'Denominator', mat2str(sys.Denominator));

% Set up step input in Simulink model
stepAmplitude = 1;
stepTime = 10; % Time when the step occurs
set_param('new_model/Step', 'Time', num2str(stepTime), 'Before', 'stepAmplitude');

% Run simulation
sim('new_model');
