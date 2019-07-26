function  f_data_extract( r_fileName )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
samplingTime = 10; %%����ʱ����
path = pwd;
%% �����ʾ��Ϣ
disp(strcat('���ڴ���',r_fileName));
disp('���Ժ�......');
%% ����Excel���
[excelData,excelStr] = xlsread(r_fileName,1);               %��ȡԭʼ���ݱ��е����ݣ�strΪ���ݱ��е��ַ���dataΪ���ݱ��е�����
[excelRow,excelColumn] = size(excelData);        %%��ȡ���ݱ��е����и���
[strRow,strColumn] = size(excelStr);                              %% ���ݱ����ַ��ĸ���
needStr = {'����','�ۼ����','GPS����','GPS���'}; %% �����¶���Ҫ��������
needData = zeros(excelRow,7);  %%��ȡ��Ҫ������������ļ��ٶ�
needStrStationIn_value = zeros(1,4);                        %% ����������ԭʼ���ݱ��е�λ��
%% �ҳ���Ҫ����������ԭʼ���ݱ��е�λ��
for i = 1 :strColumn                       
    for j = 1: 4
        if strcmp(excelStr(1,i),needStr(1,j))>0
            needStrStationIn_value(1,j) = i-1;      %% -1����Ϊ��ԭ���ݱ��е�һ��Ϊʱ�䣬MATLAB��ȡ�����ݾ�����û����һ�С�excelData��������������ԭʼexcel��һ�У���һ�С�
        end
    end
end
%% needData������Ҫ������
for i=1:4   
needData(:,i)=excelData(:,needStrStationIn_value(i));
end
%% �����Ǳ���ٶ�
for i=1:excelRow
    if i == excelRow         %%���һ��
        needData(excelRow,5)  =0;
        break;
    end
    meter_a = ((needData(i+1,1)-needData(i,1))*10/36/samplingTime);
    needData(i,5) = meter_a;
end

%% ����GPS���ٶ�
for i=1:excelRow
    if i == excelRow            %%���һ��
        needData(excelRow,6)  =0;
        break;
    end
    GPS_a = (needData(i+1,3)-needData(i,3)*10/36/samplingTime);
    needData(i,6) = GPS_a;
end
f_speed_analysis(r_fileName,needData);
%% ����ļ�����Ӧ�ļ���  ���������ĸ��ļ�������
i = find('.'==r_fileName);
imname = r_fileName(1:i-1); %% imnameΪ������׺�ļ����� 

outFile = imname;
if ~exist(outFile)   %% ���û��output�ļ��У�
%      rmdir (outFile,'s'); %%ɾ���ļ���
    mkdir(outFile);%% ����һ��Output�ļ���
end
cd(fullfile(path,outFile)); %%����outputĿ¼

poduFile = strcat(imname,'_�ٶȵ���Ϣ.xlsx'); %%��ɴ�excle�ļ�����podu�ļ���
colname={'���','ʱ��','����','�ۼ����','GPS����','GPS���','���ټ��ٶ�','GPS���ټ��ٶ�'};    %%����ÿһ�е���������
warning off MATLAB:xlswrite:AddSheet;   %%��ֹ����warning���� 
xlswrite(poduFile, colname, 'sheet1','A1');
xuhao = linspace(1,excelRow,excelRow);
xlswrite(poduFile, xuhao', 'sheet1','A2');                %%���
xlswrite(poduFile,excelStr(2:strRow,1), 'sheet1','B2');              %%ʱ��
xlswrite(poduFile,needData, 'sheet1','C2');     %%���� 

%% ���ݴ�����ϣ������ʾ��Ϣ
disp('���ݴ�����ϣ���鿴��ǰ�ļ����µ�');
disp(poduFile);
cd ..       %%�˳��ٶȵ���Ϣ���ļ���

end

