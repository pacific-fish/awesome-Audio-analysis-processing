% 加载WAV音乐文件 
clc;clear;
[signal, fs] = audioread('大作业信号2.wav'); 
  
% 提取一小段信号以便分析（可选）  
%signal = signal(fs*3:fs*3.05); 
  
% 设计一个带通滤波器，截止频率为2000Hz和4000hz 
center_freq = 3000;  
bandwidth = 2000;  
low_cutoff = center_freq - bandwidth/2;  
high_cutoff = center_freq + bandwidth/2;  
Wn = [low_cutoff/(fs/2) high_cutoff/(fs/2)]; % 归一化截止频率  
[b, a] = butter(5, Wn, 'bandpass'); % 设计5阶巴特沃斯带通滤波器  

fvtool(b, a);
% 显示B和A系数
disp('分子系数（B）：');
disp(b);
disp('分母系数（A）：');
disp(a);

% 应用滤波器  
filtered_signal = filter(b, a, signal); 
  
% 绘制原始信号和滤波后的信号  
figure;  
subplot(2, 1, 1);  
plot(0:1/fs:length(signal)/fs-1/fs, signal);  
title('Original Signal');  
xlabel('Time (s)');  
ylabel('Amplitude');  
  
subplot(2, 1, 2);  
plot(0:1/fs:length(filtered_signal)/fs-1/fs, filtered_signal); 
title('Filtered Signal');  
xlabel('Time (s)');  
ylabel('Amplitude');  
  
% 绘制频谱图以分析失真情况（可选）  
[H1, f1] = freqz(b, a, 4096, fs); % 计算滤波器的频率响应  
[Pxx1, F1] = pwelch(signal, [], [], [], fs, 'power'); % 计算原始信号的功率谱密度  
[Pxx2, F2] = pwelch(filtered_signal, [], [], [], fs, 'power'); % 计算滤波后信号的功率谱密度  
F11=F1(1:10000) ;
F21=F2(1:10000) ;
Pxx11 =Pxx1(1:10000);
Pxx21 =Pxx2(1:10000);
figure;  
plot(F11/1000,10*log(Pxx11)); % 绘制原始信号的频谱（dB）  
hold on; 
title('Spectrogram Comparison');  
xlabel('Frequency (kHz)');  
ylabel('Power/Frequency (W/Hz)');  
legend('Original Signal'); 
figure;
plot(F21/1000,10*log(Pxx21), '--b'); % 绘制滤波后信号的频谱（dB）  
title('Spectrogram Comparison');  
xlabel('Frequency (kHz)');  
ylabel('Power/Frequency (W/Hz)');  
legend('Filtered Signal');  
grid on;  
%将滤波后的wav文件导出（可选，注意文件名称）
% filename='大作业信号1_band.wav';
% audiowrite(filename,filtered_signal,40000);