%Se muestra funci�n de transferencia y formas de onda de entrada y salida
% de un fitro, modelado com Matlab y en VHDL.

close all
clear all

fs=48e3;%frecuencia de muestreo (Hz)

fid=fopen ('Vout.dat','r')
valores=textscan (fid,' %f32 %f32');
fclose (fid)
chanel_L=valores{1};
chanel_R=valores{2};%
lv=length(chanel_L);
t= [1/fs:1/fs:(lv/fs)];

subplot(2,1,1)
plot(t,chanel_L)
grid on;
title('CANAL L');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(2,1,2)
plot(t,chanel_R)
grid on;
title('CANAL R');
xlabel('Tiempo (s)');
ylabel('Amplitud');


