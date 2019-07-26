function  f_data_extract( r_fileName )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
samplingTime = 10; %%采样时间间隔
path = pwd;
%% 输出提示信息
disp(strcat('正在处理',r_fileName));
disp('请稍候......');
%% 处理Excel表格
[excelData,excelStr] = xlsread(r_fileName,1);               %读取原始数据表中的数据：str为数据表中的字符，data为数据表中的数据
[excelRow,excelColumn] = size(excelData);        %%获取数据表中的行列个数
[strRow,strColumn] = size(excelStr);                              %% 数据表中字符的个数
needStr = {'车速','累计里程','GPS车速','GPS里程'}; %% 计算坡度需要的数据项
needData = zeros(excelRow,7);  %%提取需要的数据与计算后的加速度
needStrStationIn_value = zeros(1,4);                        %% 各数据项在原始数据表中的位置
%% 找出需要的数据项在原始数据表中的位置
for i = 1 :strColumn                       
    for j = 1: 4
        if strcmp(excelStr(1,i),needStr(1,j))>0
            needStrStationIn_value(1,j) = i-1;      %% -1是因为在原数据表中第一列为时间，MATLAB读取后数据矩阵中没有这一列。excelData的行数和列数比原始excel少一行，少一列。
        end
    end
end
%% needData接收需要的数据
for i=1:4   
needData(:,i)=excelData(:,needStrStationIn_value(i));
end
%% 计算仪表加速度
for i=1:excelRow
    if i == excelRow         %%最后一行
        needData(excelRow,5)  =0;
        break;
    end
    meter_a = ((needData(i+1,1)-needData(i,1))*10/36/samplingTime);
    needData(i,5) = meter_a;
end

%% 计算GPS加速度
for i=1:excelRow
    if i == excelRow            %%最后一行
        needData(excelRow,6)  =0;
        break;
    end
    GPS_a = (needData(i+1,3)-needData(i,3)*10/36/samplingTime);
    needData(i,6) = GPS_a;
end
f_speed_analysis(r_fileName,needData);
%% 输出文件到相应文件夹  容易区别哪个文件的数据
i = find('.'==r_fileName);
imname = r_fileName(1:i-1); %% imname为不带后缀文件名称 

outFile = imname;
if ~exist(outFile)   %% 如果没有output文件夹，
%      rmdir (outFile,'s'); %%删除文件夹
    mkdir(outFile);%% 创建一个Output文件夹
end
cd(fullfile(path,outFile)); %%进入output目录

poduFile = strcat(imname,'_速度等信息.xlsx'); %%组成带excle文件名的podu文件名
colname={'序号','时间','车速','累计里程','GPS车速','GPS里程','车速加速度','GPS车速加速度'};    %%增加每一列的数据名称
warning off MATLAB:xlswrite:AddSheet;   %%防止出现warning警告 
xlswrite(poduFile, colname, 'sheet1','A1');
xuhao = linspace(1,excelRow,excelRow);
xlswrite(poduFile, xuhao', 'sheet1','A2');                %%序号
xlswrite(poduFile,excelStr(2:strRow,1), 'sheet1','B2');              %%时间
xlswrite(poduFile,needData, 'sheet1','C2');     %%数据 

%% 数据处理完毕，输出提示信息
disp('数据处理完毕，请查看当前文件夹下的');
disp(poduFile);
cd ..       %%退出速度等信息表文件夹

end

