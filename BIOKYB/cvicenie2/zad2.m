% Read the table from the CSV file
AP = readtable('IVGTT_data/Dat_IVGTT_AP.csv');
SN = readtable('IVGTT_data/Dat_IVGTT_SN.csv');
RI = readtable('IVGTT_data/Dat_IVGTT_RI.csv');
VR = readtable('IVGTT_data/Dat_IVGTT_VanRiel.csv');

% Extract the data you want to plot (assuming the first column)
ap_time= AP{:, 1};
ap_glucose = AP{:, 2};
ap_insulin = AP{:, 3};
% Create a figure and plot the data
figure(1);
plot(ap_time,ap_glucose,ap_time,ap_insulin)

% Add labels and title if needed
xlabel('Time [s]');
title('Glycemia and Insulin, AP');
legend('Glycemia [mmol/l]','Insulin [mIU/l]')

% Extract the data you want to plot (assuming the first column)
sn_time= SN{:, 1};
sn_glucose = SN{:, 2};
sn_insulin = SN{:, 3};
% Create a figure and plot the data
figure(2);
plot(sn_time,sn_glucose,sn_time,sn_insulin)

% Add labels and title if needed
xlabel('Time [s]');
title('Glycemia and Insulin, SN');
legend('Glycemia [mmol/l]','Insulin [mIU/l]')

% Extract the data you want to plot (assuming the first column)
ri_time= RI{:, 1};
ri_glucose = RI{:, 2};
ri_insulin = RI{:, 3};
% Create a figure and plot the data
figure(3);
plot(ri_time,ri_glucose,ri_time,ri_insulin)

% Add labels and title if needed
xlabel('Time [s]');
title('Glycemia and Insulin, RI');
legend('Glycemia [mmol/l]','Insulin [mIU/l]')

% Extract the data you want to plot (assuming the first column)
vr_time= VR{:, 1};
vr_glucose_mg_dl = VR{:, 2};
vr_insulin_uU_l = VR{:, 3};
% Create a figure and plot the data
figure(4);
plot(vr_time,(vr_glucose_mg_dl/18),vr_time,vr_insulin_uU_l)

% Add labels and title if needed
xlabel('Time [s]');
title('Glycemia and Insulin, VR');
legend('Glycemia [mmol/l]','Insulin [mIU/l]')

Gb = AP{1,2}
Ib = Ap{1,3}
I = AP{:, 1:2:3};

%unknown
p2 = 1.0160e-04
Si = 1.3612e-01
Sg = 3.6105e-02

ap_G = AP{:,1:2}

figure(1);
hold on
plot(out.G.Time,out.G.Data,'x')
hold off
figure(5)
plot(out.x.Time,out.x.Data,'o')


