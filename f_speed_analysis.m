function f_speed_analysis(r_fileName,r_excelData)
%r_excelData 接收到的速度等数据
%   Detailed explanation goes here
path=pwd;
i = find('.'==r_fileName);
imname = r_fileName(1:i-1); %% imname为不带后缀文件名称 

samplingTime = 10; %%采样时间间隔
dataSize = size(r_excelData);%%数据的个数 行数=dataSize(1) 列数=dataSize(2)
maxSpeed = max(r_excelData(:,1));   %%最大车速
averageSpeed = mean(r_excelData(:,1));%%平均车速
%% 求车速分段占比
[sortVelocity,index] = sort(r_excelData(:,1)); %% 车速排序--升序
speed_num =  zeros(9,1);  % 车速占比个数
stopTime_num = 0; %%怠速时间个数
for i=1:dataSize(1)
    if sortVelocity(i,1)<10
        if sortVelocity(i,1) <0.04 %%车速小于0.04认为车速=0。
            stopTime_num =stopTime_num+1 ; %%用于计算怠速时间
        else
            speed_num(1,1) = speed_num(1,1)+1; %% 去除速度怠速后的数据
        end
        
    elseif sortVelocity(i,1)<20
        speed_num(2,1) = speed_num(2,1)+1;
    elseif sortVelocity(i,1)<30
        speed_num(3,1) = speed_num(3,1)+1;
    elseif sortVelocity(i,1)<40
        speed_num(4,1) = speed_num(4,1)+1;
    elseif sortVelocity(i,1)<50
        speed_num(5,1) = speed_num(5,1)+1;
    elseif sortVelocity(i,1)<60
        speed_num(6,1) = speed_num(6,1)+1;
    elseif sortVelocity(i,1)<70
        speed_num(7,1) = speed_num(7,1)+1;
    elseif sortVelocity(i,1)<80
        speed_num(8,1) = speed_num(8,1)+1;
    elseif sortVelocity(i,1)<90
        speed_num(9,1) = speed_num(9,1)+1;
    end
end


%% 加速度计算
maxAcceleratedSpeed = max(r_excelData(:,5));   %%最大加速度
minAcceleratedSpeed = min(r_excelData(:,5));   %%最小加速度（最大减速度）
% averageAcceleratedSpeed = mean(r_excelData(:,5));%%平均加速度
%% 求加速度分段占比
[sortAcceleratedSpeed,a_index] = sort(r_excelData(:,5)); %% 车速排序--升序
acceleratedSpeed_num =  zeros(10,1);  % 加速度（减速度/加速度）占比个数
for i=1:dataSize(1)
    if(sortAcceleratedSpeed(i,1)<-2.0) %%负加速度（减速度）
        acceleratedSpeed_num(1,1) =acceleratedSpeed_num(1,1)+1;
    elseif sortAcceleratedSpeed(i,1)<-1.5
        acceleratedSpeed_num(2,1) =acceleratedSpeed_num(2,1)+1;
    elseif sortAcceleratedSpeed(i,1)<-1.0
        acceleratedSpeed_num(3,1) =acceleratedSpeed_num(3,1)+1;
    elseif sortAcceleratedSpeed(i,1)<-0.5
        acceleratedSpeed_num(4,1) =acceleratedSpeed_num(4,1)+1;
    elseif sortAcceleratedSpeed(i,1)<0
        acceleratedSpeed_num(5,1) =acceleratedSpeed_num(5,1)+1;
    elseif sortAcceleratedSpeed(i,1)<0.5
        acceleratedSpeed_num(6,1) =acceleratedSpeed_num(6,1)+1;
    elseif sortAcceleratedSpeed(i,1)<1.0
        acceleratedSpeed_num(7,1) =acceleratedSpeed_num(7,1)+1;
    elseif sortAcceleratedSpeed(i,1)<1.5
        acceleratedSpeed_num(8,1) = acceleratedSpeed_num(8,1)+1;
    elseif sortAcceleratedSpeed(i,1)<2.0
        acceleratedSpeed_num(9,1) =acceleratedSpeed_num(9,1)+1;
    else
        acceleratedSpeed_num(10,1) =acceleratedSpeed_num(10,1)+1;
    end
end

negative = sum(sortAcceleratedSpeed(:,1)<0); %%减速度个数
positive = sum(sortAcceleratedSpeed(:,1)>0);  %%加速度个数
zeroo = sum(sortAcceleratedSpeed(:,1)==0);  %%加速度=0的个数
averageDecSpeed =mean(sortAcceleratedSpeed(1:positive)); %%平均减速度
averageAccSpeed = mean(sortAcceleratedSpeed(positive+zeroo:positive+zeroo+negative)); %%平均加速度
%% 行驶时间
driveTime = dataSize(1)*samplingTime; %%采样时间间隔*数据个数=行驶时间
%% 行驶距离 
driveDistance = r_excelData(dataSize(1),2)-r_excelData(1,2); %%结束时累计里程-开始时累计里程
%% 怠速时间
stopTime = samplingTime*stopTime_num; %%时间等于0的个数*采集时间间隔


%% 匀速行驶
constantSpeed_Table = zeros(dataSize(1),3); %%记录匀速的时间，速度值  （时间|持续时间|速度值）
constantSpeed_Flah = 0;
for i=2:dataSize(1)-2
    if (constantSpeed_Flah == 0)&&(abs(r_excelData(i-1,1)-r_excelData(i,1))<1)&&(abs(r_excelData(i+1,1)-r_excelData(i,1))<1)
        constantSpeed_Flah = 1; %%连接三个数度值相差不到1km/h，认为车辆匀速行驶，速度值为r_excelData(i,1)。                                                                                                                                            匀速计算
        constantSpeed = r_excelData(i,1);
        constantSpeed_num = 3;
        constantSpeed_Table(i-1,1)=1;
        constantSpeed_Table(i,1)=1;
        constantSpeed_Table(i+1,1)=1;%%记录匀速时间
    end
    if (constantSpeed_Flah == 1) &&(abs(r_excelData(i+2,1)-constantSpeed)<1)
        constantSpeed_num = constantSpeed_num+1; 
        constantSpeed_Table(i+2,1)=1;%%记录匀速时间
        constantSpeed_Table(i+2,2)=constantSpeed_num;%%持续时间
        if constantSpeed <1  %%因为会出现0.04的速度，此时认为速度为0
            constantSpeed = 0;
        end
        constantSpeed_Table(i+2,3)=constantSpeed; %%匀速速度
    else
        constantSpeed_Flah = 0;
        constantSpeed_num = 0;
        continue;
    end 
end
%% 加速度分段
temp_table=zeros(dataSize(1),12); %% 0-15 | 0-30 | 0-50 | 0-70 | 40-70 |50-70  (加速度|减速度)
for i=1:dataSize(1)
    if (r_excelData(i,1)>0) && (r_excelData(i,1)<15) %% 0-15
        if(r_excelData(i,5) >0) %%加速度>0
            temp_table(i,1) = r_excelData(i,5);
        elseif (r_excelData(i,5) <0)
            temp_table(i,2) = r_excelData(i,5);
        end
    end 
end %% 0-15 
for i=1:dataSize(1)
    if(r_excelData(i,1)>0) && (r_excelData(i,1)<30) %% 0-30
        if(r_excelData(i,5) >0)
            temp_table(i,3) = r_excelData(i,5);
        elseif (r_excelData(i,5) <0)
            temp_table(i,4) = r_excelData(i,5);
        end
    end 
end %% 0-30 
for i=1:dataSize(1)
    if(r_excelData(i,1)>0) && (r_excelData(i,1)<40) %% 0-50
        if(r_excelData(i,5) >0)
            temp_table(i,5) = r_excelData(i,5);
        elseif (r_excelData(i,5) <0)
            temp_table(i,6) = r_excelData(i,5);
        end
    end 
end %% 0-40
for i=1:dataSize(1)
    if(r_excelData(i,1)>0) && (r_excelData(i,1)<50) %% 0-50
        if(r_excelData(i,5) >0)
            temp_table(i,7) = r_excelData(i,5);
        elseif (r_excelData(i,5) <0)
            temp_table(i,8) = r_excelData(i,5);
        end
    end 
end %% 0-50
for i=1:dataSize(1)
    if(r_excelData(i,1)>0) && (r_excelData(i,1)<70) %% 0-70
        if(r_excelData(i,5) >0)
            temp_table(i,9) = r_excelData(i,5);
        elseif (r_excelData(i,5) <0)
            temp_table(i,10) = r_excelData(i,5);
        end
    end 
end %% 0-70
%% 40-70 
for i=1:dataSize(1)
    if(r_excelData(i,1)>40) && (r_excelData(i,1)<70) %% 0-70
        if(r_excelData(i,5) >0)
            temp_table(i,11) = r_excelData(i,5);
        elseif (r_excelData(i,5) <0)
            temp_table(i,12) = r_excelData(i,5);
        end
    end 
end %% 0-70

speed015AccSpd_num=sum(temp_table(:,1)>0); %% 速度0-15km/h间加速度个数
average015AccSpd = sum(temp_table(:,1))/speed015AccSpd_num; %% 速度0-15km/h间平均加速度
average015DecSpd= sum(temp_table(:,2))/sum(temp_table(:,2)<0); %% 速度0-15km/h间平均减速度
average030AccSpd = sum(temp_table(:,3))/sum(temp_table(:,3)>0); %% 速度0-30km/h间平均加速度
average030DecSpd = sum(temp_table(:,4))/sum(temp_table(:,4)<0); %% 速度0-30km/h间平均减速度
average040AccSpd = sum(temp_table(:,5))/sum(temp_table(:,5)>0); %% 速度0-40km/h间平均加速度
average040DecSpd = sum(temp_table(:,6))/sum(temp_table(:,6)<0); %% 速度0-40km/h间平均减速度
average050AccSpd = sum(temp_table(:,7))/sum(temp_table(:,7)>0); %% 速度0-50km/h间平均加速度
average050DecSpd = sum(temp_table(:,8))/sum(temp_table(:,8)<0); %% 速度0-50km/h间平均减速度
average070AccSpd = sum(temp_table(:,9))/sum(temp_table(:,9)>0); %% 速度0-70km/h间平均加速度
average070DecSpd = sum(temp_table(:,10))/sum(temp_table(:,10)<0); %% 速度0-70km/h间平均减速度
average4070AccSpd = sum(temp_table(:,11))/sum(temp_table(:,11)>0); %% 速度40-70km/h间平均加速度
average4070DecSpd = sum(temp_table(:,12))/sum(temp_table(:,12)<0); %% 速度40-70km/h间平均减速度
%% 0-30间平均速度  分段平均速度   30-40|40-50|20-30|0-40|20-30
averageSpeedTemp_table=zeros(dataSize(1),12); %% 
for i=1:dataSize(1)
    if(r_excelData(i,1)>20) && (r_excelData(i,1)<30) %% 0-30
        averageSpeedTemp_table(i,3) = r_excelData(i,1);
    end 
end %% 30-40间平均速度
% averageSpeed2030 = sum(averageSpeedTemp_table(:,3))/sum(averageSpeedTemp_table(:,3)>0); %%0-30间平均速度
%% 0-40间平均速度  分段平均速度   30-40|40-50|0-30|0-40
for i=1:dataSize(1)
    if(r_excelData(i,1)>0.02) && (r_excelData(i,1)<40) %% 0-30
        averageSpeedTemp_table(i,4) = r_excelData(i,1);
    end 
end %% 30-40间平均速度

%% 30-40间平均速度  分段平均速度   30-40|40-50|
% averageSpeedTemp_table=zeros(dataSize(1),12); %% 30-40
for i=1:dataSize(1)
    if(r_excelData(i,1)>30) && (r_excelData(i,1)<40) %% 0-70
        averageSpeedTemp_table(i,1) = r_excelData(i,1);
    end 
end %% 30-40间平均速度
% averageSpeed3040 = sum(averageSpeedTemp_table(:,1))/sum(averageSpeedTemp_table(:,1)>0); %%30-40间平均速度
%% 40-50间平均速度  分段平均速度
for i=1:dataSize(1)
    if(r_excelData(i,1)>40) && (r_excelData(i,1)<50) %% 0-70
        averageSpeedTemp_table(i,2) = r_excelData(i,1);
    end 
end %% 30-40间平均速度
averageSpeed3040 = sum(averageSpeedTemp_table(:,1))/sum(averageSpeedTemp_table(:,1)>0); %%30-40间平均速度
averageSpeed4050 = sum(averageSpeedTemp_table(:,2))/sum(averageSpeedTemp_table(:,2)>0); %%40-50间平均速度
averageSpeed2030 = sum(averageSpeedTemp_table(:,3))/sum(averageSpeedTemp_table(:,3)>0); %%0-30间平均速度
averageSpeed040 = sum(averageSpeedTemp_table(:,4))/sum(averageSpeedTemp_table(:,4)>0); %%0-30间平均速度
%% 输出文件到相应文件夹  容易区别哪个文件的数据
outFile = imname;
if ~exist(outFile)   %% 如果没有output文件夹，
%      rmdir (outFile,'s'); %%删除文件夹
    mkdir(outFile);%% 创建一个Output文件夹
end
cd(fullfile(path,outFile)); %%进入output目录

xlswrite('加速度分段', temp_table, 'sheet1','A1');                %%序号
cd ..
a1=sum(temp_table(:,1))/nnz(temp_table(:,1));
a2=sum(temp_table(:,2))/nnz(temp_table(:,2));
a3=sum(temp_table(:,3))/nnz(temp_table(:,3));
a4=sum(temp_table(:,4))/nnz(temp_table(:,4));
a5=sum(temp_table(:,5))/nnz(temp_table(:,5));
a6=sum(temp_table(:,6))/nnz(temp_table(:,6));
b1=sqrt(sum(temp_table(:,1).^2)/nnz(temp_table(:,1)));
b2=sqrt(sum(temp_table(:,2).^2)/nnz(temp_table(:,2)));
b3=sqrt(sum(temp_table(:,3).^2)/nnz(temp_table(:,3)));
b4=sqrt(sum(temp_table(:,4).^2)/nnz(temp_table(:,4)));
b5=sqrt(sum(temp_table(:,5).^2)/nnz(temp_table(:,5)));
b6=sqrt(sum(temp_table(:,6).^2)/nnz(temp_table(:,6)));


%% 速度分段--每段速度区间的个数
speedTemp_table=zeros(dataSize(1),7); %% 0-10 | 10-20 | 20-30 | 30-40 | 40-50 |50-60 |60-70 
for i=1:dataSize(1)
    if (r_excelData(i,1)>0) && (r_excelData(i,1)<10) %% 0-15
        if r_excelData(i,1)>0.04
            speedTemp_table(i,1)=r_excelData(i,1);
        end
    elseif r_excelData(i,1)<20
        speedTemp_table(i,2)=r_excelData(i,1);
    elseif r_excelData(i,1)<30
        speedTemp_table(i,3)=r_excelData(i,1);
    elseif r_excelData(i,1)<40
        speedTemp_table(i,4)=r_excelData(i,1);
    elseif r_excelData(i,1)<50
        speedTemp_table(i,5)=r_excelData(i,1);
    elseif r_excelData(i,1)<60
        speedTemp_table(i,6)=r_excelData(i,1);
    elseif r_excelData(i,1)<70
        speedTemp_table(i,7)=r_excelData(i,1);
    end 
end %% 0-10 

sudugeshu = zeros(1,7);  %% 统计各段的数据个数
sudugeshu(1,1)=nnz(speedTemp_table(:,1));
sudugeshu(1,2)=nnz(speedTemp_table(:,2));
sudugeshu(1,3)=nnz(speedTemp_table(:,3));
sudugeshu(1,4)=nnz(speedTemp_table(:,4));
sudugeshu(1,5)=nnz(speedTemp_table(:,5));
sudugeshu(1,6)=nnz(speedTemp_table(:,6));
sudugeshu(1,7)=nnz(speedTemp_table(:,7));

%% 输出文件到相应文件夹  容易区别哪个文件的数据
outFile = imname;
if ~exist(outFile')   %% 如果没有output文件夹，
%      rmdir (outFile,'s'); %%删除文件夹
    mkdir(outFile);%% 创建一个Output文件夹
end
cd(fullfile(path,outFile)); %%进入output目录
%% 速度分段
xlswrite('速度分段', speedTemp_table, 'sheet1','A1');                %%速度分段
%% 匀速统计表
xlswrite('匀速统计表', constantSpeed_Table, 'sheet1','A1');                %%匀速统计表
%% word 设置
cd ..
path=pwd; %%获取当前路径

%% 输出文件到相应文件夹  容易区别哪个文件的数据
%% 生成WORD
outFile = imname;
if ~exist(imname)   %% 如果没有output文件夹，
%      rmdir (outFile,'s'); %%删除文件夹
    mkdir(imname);%% 创建一个Output文件夹
end
cd(fullfile(path,imname)); %%进入output目录
i = find('.'==r_fileName);
imname = r_fileName(1:i-1); %% imname为不带后缀文件名称 
disp(strcat('正在处理',imname));
disp('请稍候......');
string = strcat(imname,'数据分析报告'); %%组成带excle文件名的podu文件名
doc_f='.doc';
spwd=[pwd '\'];
file_name =[spwd string doc_f];
try
    Word=actxGetRunningServer('Word.Application');
catch
    Word = actxserver('Word.Application');
    
end;
set(Word, 'Visible', 1);
documents = Word.Documents;
if exist(file_name,'file')
    document = invoke(documents,'Open',file_name);% 以Excel文件名保存分析报告。
else
    document = invoke(documents, 'Add');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
content = document.Content;
duplicate = content.Duplicate;
inlineshapes = content.InlineShapes;
selection= Word.Selection;
paragraphformat = selection.ParagraphFormat;
shape=document.Shapes;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 页面设置
document.PageSetup.TopMargin = 60;
document.PageSetup.BottomMargin = 50;
document.PageSetup.LeftMargin = 60;
document.PageSetup.RightMargin = 60;
set(content, 'Start',0);
set(content, 'Text',string);
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
% selection.Font.Size=50;
rr=document.Range(0,length(string));%选择文本
rr.Font.Size=20;%设置文本字体
%rr.Font.Bold=4;%设置文本字体 加粗 
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.MoveDown;
selection.TypeParagraph;

%% 表格 说明
selection.MoveDown;
selection.TypeParagraph;
set(paragraphformat, 'Alignment','wdAlignParagraphJustify');
set(selection, 'Text','1. 根据收集的数据做出数据统计表格如下所示：');
selection.Font.Size=10;
selection.MoveDown;
selection.TypeParagraph;
%% 画表格1
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
% selection.TypeParagraph;
set(selection, 'Text','表2： 车速分段占比');
selection.Font.Size=8;
selection.MoveDown;
Tables=document.Tables.Add(selection.Range,8,2);
DTI=document.Tables.Item(1);
DTI.Borders.OutsideLineStyle='wdLineStyleSingle';
DTI.Borders.OutsideLineWidth='wdLineWidth150pt';
DTI.Borders.InsideLineStyle='wdLineStyleSingle';
DTI.Borders.InsideLineWidth='wdLineWidth150pt';
DTI.Rows.Alignment='wdAlignRowCenter';
column_width=[80.575,70.7736];
row_height=[20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849];
for i=1:2
DTI.Columns.Item(i).Width=column_width(i);
end
for i=1:8
DTI.Rows.Item(i).Height =row_height(i);
end
for i=1:8
for j=1:2
      DTI.Cell(i,j).VerticalAlignment='wdCellAlignVerticalCenter';
end
end
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.TypeParagraph;
DTI.Cell(1,1).Range.Text = '项目';%不需要更改
DTI.Cell(1,2).Range.Text = '值';
DTI.Cell(2,1).Range.Text = '测试时间 s';%不需要更改
DTI.Cell(3,1).Range.Text = '测试距离 km';
DTI.Cell(4,1).Range.Text = '平均车速 km/h';
DTI.Cell(5,1).Range.Text = '最大车速 km/h';
DTI.Cell(6,1).Range.Text = '最小加速度 m/s^2';
DTI.Cell(7,1).Range.Text = '最大加速度 m/s^2';
DTI.Cell(8,1).Range.Text = '怠速时间 s';
DTI.Cell(2,2).Range.Text = num2str(driveTime);
DTI.Cell(3,2).Range.Text = num2str(driveDistance);
DTI.Cell(4,2).Range.Text = num2str(averageSpeed);
DTI.Cell(5,2).Range.Text = num2str(maxSpeed);
DTI.Cell(6,2).Range.Text = num2str(minAcceleratedSpeed);
DTI.Cell(7,2).Range.Text = num2str(maxAcceleratedSpeed);
DTI.Cell(8,2).Range.Text = num2str(stopTime_num*samplingTime);

%% 画表格2 
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
% selection.TypeParagraph;
set(selection, 'Text','表2： 车速分段占比');
selection.Font.Size=8;
selection.MoveDown;
Tables=document.Tables.Add(selection.Range,13,3);
DTI2=document.Tables.Item(2);
DTI2.Borders.OutsideLineStyle='wdLineStyleSingle';
DTI2.Borders.OutsideLineWidth='wdLineWidth150pt';
DTI2.Borders.InsideLineStyle='wdLineStyleSingle';
DTI2.Borders.InsideLineWidth='wdLineWidth150pt';
DTI2.Rows.Alignment='wdAlignRowCenter';
column_width2=[80.575,70.7736,60.7736];
row_height2=[20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849];
for i=1:3
DTI2.Columns.Item(i).Width=column_width2(i);
end
for i=1:13
DTI2.Rows.Item(i).Height =row_height2(i);
end
for i=1:13
for j=1:3
      DTI2.Cell(i,j).VerticalAlignment='wdCellAlignVerticalCenter';
end
end
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.TypeParagraph;

DTI2.Cell(1,1).Range.Text = '项次';%不需要更改
DTI2.Cell(2,1).Range.Text = '最高车速(km/h)';
DTI2.Cell(3,1).Range.Text = '平均车速(km/h)';
DTI2.Cell(4,1).Range.Text = '车速占比';
DTI2.Cell(4,2).Range.Text = '怠速 (km/h)';
DTI2.Cell(5,2).Range.Text = '0-10(km/h)';
DTI2.Cell(6,2).Range.Text = '10-20(km/h)';
DTI2.Cell(7,2).Range.Text = '20-30(km/h)';
DTI2.Cell(8,2).Range.Text = '30-40(km/h)';
DTI2.Cell(9,2).Range.Text = '40-50(km/h)';
DTI2.Cell(10,2).Range.Text = '50-60(km/h)';
DTI2.Cell(11,2).Range.Text = '60-70(km/h)';
DTI2.Cell(12,2).Range.Text = '70-80(km/h)';
DTI2.Cell(13,2).Range.Text = '80-90(km/h)';

DTI2.Cell(1,3).Range.Text = '数值';%不需要更改
DTI2.Cell(2,3).Range.Text = num2str(maxSpeed );%采集时间
DTI2.Cell(3,3).Range.Text = num2str(averageSpeed);%行驶距离

DTI2.Cell(4,3).Range.Text = num2str(sprintf('%2.2f%%', (stopTime_num/dataSize(1))*100));%怠速占比  
DTI2.Cell(5,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(1,1)/dataSize(1))*100));%车速占比  
DTI2.Cell(6,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(2,1)/dataSize(1))*100));%车速占比
DTI2.Cell(7,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(3,1)/dataSize(1))*100));%车速占比
DTI2.Cell(8,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(4,1)/dataSize(1))*100));%车速占比
DTI2.Cell(9,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(5,1)/dataSize(1))*100));%车速占比
DTI2.Cell(10,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(6,1)/dataSize(1))*100));%车速占比
DTI2.Cell(11,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(7,1)/dataSize(1))*100));%车速占比
DTI2.Cell(12,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(8,1)/dataSize(1))*100));%车速占比
DTI2.Cell(13,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(9,1)/dataSize(1))*100));%车速占比

%% 合并单元格
DTI2.Cell(1, 1).Merge(DTI2.Cell(1, 2));
DTI2.Cell(2, 1).Merge(DTI2.Cell(2, 2));
DTI2.Cell(3, 1).Merge(DTI2.Cell(3, 2));
DTI2.Cell(4, 1).Merge(DTI2.Cell(13, 1));

%% 画表格3 
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
% selection.TypeParagraph;
set(selection, 'Text','表3： 加速度分段占比');
selection.Font.Size=8;
selection.MoveDown;
Tables=document.Tables.Add(selection.Range,13,3);
DTI2=document.Tables.Item(3);
DTI2.Borders.OutsideLineStyle='wdLineStyleSingle';
DTI2.Borders.OutsideLineWidth='wdLineWidth150pt';
DTI2.Borders.InsideLineStyle='wdLineStyleSingle';
DTI2.Borders.InsideLineWidth='wdLineWidth150pt';
DTI2.Rows.Alignment='wdAlignRowCenter';
column_width2=[80.575,80.7736,60.7736];
row_height2=[20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849];
for i=1:3
DTI2.Columns.Item(i).Width=column_width2(i);
end
for i=1:13
DTI2.Rows.Item(i).Height =row_height2(i);
end
for i=1:13
for j=1:3
      DTI2.Cell(i,j).VerticalAlignment='wdCellAlignVerticalCenter';
end
end
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.TypeParagraph;
DTI2.Cell(1,1).Range.Text = '项次';%不需要更改
DTI2.Cell(2,1).Range.Text = '最大加速度 m/s^2';
DTI2.Cell(3,1).Range.Text = '最小加速度 m/s^2';
DTI2.Cell(4,1).Range.Text = '加速度占比';
DTI2.Cell(4,2).Range.Text = '>=2.0 m/s^2 ';
DTI2.Cell(5,2).Range.Text = '1.5<acc<2.0 m/s^2';
DTI2.Cell(6,2).Range.Text = '1.0<acc<1.5 m/s^2';
DTI2.Cell(7,2).Range.Text = '0.5<acc<1.0 m/s^2';
DTI2.Cell(8,2).Range.Text = '0<acc<0.5 m/s^2';
DTI2.Cell(9,2).Range.Text = '-0.5<acc<0 m/s^2';
DTI2.Cell(10,2).Range.Text = '-1.0<acc<-0.5 m/s^2';
DTI2.Cell(11,2).Range.Text = '-1.5<acc<-1.0 m/s^2';
DTI2.Cell(12,2).Range.Text = '-2.0<acc<-1.5 m/s^2';
DTI2.Cell(13,2).Range.Text = 'acc<-2.0 m/s^2';

DTI2.Cell(1,3).Range.Text = '数值';%不需要更改
DTI2.Cell(2,3).Range.Text = num2str(maxAcceleratedSpeed);%采集时间
DTI2.Cell(3,3).Range.Text = num2str(minAcceleratedSpeed);%行驶距离

DTI2.Cell(4,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(10,1)/dataSize(1))*100));%车速占比  
DTI2.Cell(5,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(9,1)/dataSize(1))*100));%车速占比
DTI2.Cell(6,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(8,1)/dataSize(1))*100));%车速占比
DTI2.Cell(7,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(7,1)/dataSize(1))*100));%车速占比
DTI2.Cell(8,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(6,1)/dataSize(1))*100));%车速占比
DTI2.Cell(9,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(5,1)/dataSize(1))*100));%车速占比
DTI2.Cell(10,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(4,1)/dataSize(1))*100));%车速占比
DTI2.Cell(11,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(3,1)/dataSize(1))*100));%车速占比
DTI2.Cell(12,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(2,1)/dataSize(1))*100));%车速占比
DTI2.Cell(13,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(1,1)/dataSize(1))*100));%车速占比

%% 合并单元格
DTI2.Cell(1, 1).Merge(DTI2.Cell(1, 2));
DTI2.Cell(2, 1).Merge(DTI2.Cell(2, 2));
DTI2.Cell(3, 1).Merge(DTI2.Cell(3, 2));
DTI2.Cell(4, 1).Merge(DTI2.Cell(13, 1));

%% 画表格4 
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
% selection.TypeParagraph;
set(selection, 'Text','表4： 画路谱需要的数据');
selection.Font.Size=8;
selection.MoveDown;
Tables=document.Tables.Add(selection.Range,16,3);
DTI2=document.Tables.Item(4);
DTI2.Borders.OutsideLineStyle='wdLineStyleSingle';
DTI2.Borders.OutsideLineWidth='wdLineWidth150pt';
DTI2.Borders.InsideLineStyle='wdLineStyleSingle';
DTI2.Borders.InsideLineWidth='wdLineWidth150pt';
DTI2.Rows.Alignment='wdAlignRowCenter';
column_width2=[80.575,80.7736,60.7736];
row_height2=[20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849,20.5849];
for i=1:3
DTI2.Columns.Item(i).Width=column_width2(i);
end
for i=1:16
DTI2.Rows.Item(i).Height =row_height2(i);
end
for i=1:16
for j=1:3
      DTI2.Cell(i,j).VerticalAlignment='wdCellAlignVerticalCenter';
end
end
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.TypeParagraph;
DTI2.Cell(1,1).Range.Text = '项次';%不需要更改
DTI2.Cell(2,1).Range.Text = '最大速度 km/h';
DTI2.Cell(3,1).Range.Text = '平均速度 km/h';
DTI2.Cell(4,1).Range.Text = '最大加速度 m/s^2';
DTI2.Cell(5,1).Range.Text = '平均加速度 m/s^2 ';
DTI2.Cell(6,1).Range.Text = '最大减速度 m/s^2';
DTI2.Cell(7,1).Range.Text = '平均减速度 m/s^2';
DTI2.Cell(8,1).Range.Text = '怠速时间 s';
DTI2.Cell(9,1).Range.Text = '0-15平均加速度';
DTI2.Cell(10,1).Range.Text = '0-40平均加速度';
DTI2.Cell(11,1).Range.Text = '0-40平均减速度';
DTI2.Cell(12,1).Range.Text = '0-40间平均速度';
DTI2.Cell(13,1).Range.Text = '20-30间平均速度';
DTI2.Cell(14,1).Range.Text = '30-40间平均速度';
DTI2.Cell(15,1).Range.Text = '40-50间平均速度';
DTI2.Cell(16,1).Range.Text = '最大车速-40间的平均减速度';

DTI2.Cell(1,3).Range.Text = '数值';%不需要更改
DTI2.Cell(2,3).Range.Text = num2str(maxSpeed);%最大速度
DTI2.Cell(3,3).Range.Text = num2str(averageSpeed);%平均速度
DTI2.Cell(4,3).Range.Text = num2str(maxAcceleratedSpeed);%最大加速度  
DTI2.Cell(5,3).Range.Text = num2str(averageAccSpeed);%平均加速度
DTI2.Cell(6,3).Range.Text = num2str(minAcceleratedSpeed);%最大减速度
DTI2.Cell(7,3).Range.Text = num2str(averageDecSpeed);%平均减速度
DTI2.Cell(8,3).Range.Text = num2str(stopTime_num*10);%怠速时间
DTI2.Cell(9,3).Range.Text = num2str(average015AccSpd);%0-15平均加速度
DTI2.Cell(10,3).Range.Text = num2str(average040AccSpd);%0-40平均加速度
DTI2.Cell(11,3).Range.Text = num2str(average040DecSpd);%30-40间平均减速度
DTI2.Cell(12,3).Range.Text = num2str(averageSpeed040);%0-40间平均速度
DTI2.Cell(13,3).Range.Text = num2str(averageSpeed2030);%20-30间平均速度
DTI2.Cell(14,3).Range.Text = num2str(averageSpeed3040);%30-40间平均速度
DTI2.Cell(15,3).Range.Text = num2str(averageSpeed4050);%40-50间平均速度
DTI2.Cell(16,3).Range.Text = num2str(average4070DecSpd);%最大车速-40间的平均减速度



%% 绘制图1 车速曲线
figure;
plot(r_excelData(:,1),'r-');%%车速
hold on;
grid on;%%显示网格线
legend('时间车速曲线');
title('时间车速曲线');
xlabel('时间 s');
ylabel('车速 km/h');

%% 将图形粘贴到当前文档里
print -dbitmap %% 复制曲线图
selection.Range.Paste;
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.MoveDown;
%% 图1 说明
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
selection.TypeParagraph;
set(selection, 'Text','图1： 时间车速曲线');
selection.Font.Size=8;
selection.MoveDown;
selection.TypeParagraph;
close;                  % 关闭Figure
%% 绘制图2 加速度曲线
figure;
xuhao = linspace(1,dataSize(1),dataSize(1));
plot(xuhao',r_excelData(:,5),'r.');%%加速度
hold on;
grid on; %% 显示网格线
legend('时间加速度曲线');
title('时间加速度曲线');
xlabel('时间 s');
ylabel('车速 m/s^2');
%% 将图形粘贴到当前文档里
print -dbitmap %% 复制曲线图
selection.Range.Paste;
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.MoveDown;
%% 图2 说明
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
selection.TypeParagraph;
set(selection, 'Text','图2： 时间加速度曲线');
selection.Font.Size=8;
selection.MoveDown;
selection.TypeParagraph;
close;                  % 关闭Figure

%% 绘制图3 速度-加速度曲线
figure;
plot(sortVelocity(:,1),r_excelData(:,5),'r.');
hold on;
grid on; %% 显示网格线
legend('速度加速度曲线');
title('速度加速度曲线');
xlabel('速度 km/h');
ylabel('车速 m/s^2');
%% 将图形粘贴到当前文档里
print -dbitmap %% 复制曲线图
selection.Range.Paste;
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.MoveDown;
%% 图3 说明
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
selection.TypeParagraph;
set(selection, 'Text','图3： 速度加速度曲线');
selection.Font.Size=8;
selection.MoveDown;
selection.TypeParagraph;
close;                  % 关闭Figure
%% 绘制图4 速度分段个数统计
figure;
bar(sudugeshu,'stacked');  %%柱状图显示各速度段个数
set(gca,'XTickLabel',{'0-10','10-20','20-30','30-40','40-50','50-60','60-70'});
hold on;
% grid on; %% 显示网格线
legend('速度分段统计');
title('速度分段统计柱状图');
xlabel('速度区间 km/h');
ylabel('个数 个');
%% 将图形粘贴到当前文档里
print -dbitmap %% 复制曲线图
selection.Range.Paste;
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.MoveDown;
%% 图4 说明
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
selection.TypeParagraph;
set(selection, 'Text','图3： 速度加速度曲线');
selection.Font.Size=8;
selection.MoveDown;
selection.TypeParagraph;
close;                  % 关闭Figure


%% 保存文档
Document.ActiveWindow.ActivePane.View.Type = 'wdPrintView';
document = invoke(document,'SaveAs',file_name); % 保存文档
Word.Quit; % 关闭文档
disp(strcat(imname,'文档处理完毕！请在当前文件夹中查看！'));%% 提示信息xxxx文档处理完毕
system('taskkill /F /IM WINWORD.EXE');% 结束excel进程
cd ..       %%退出output目录


%%          文件名|最大速度|平均速度|最大加速度|平均加速度|最大减速度|平均减速度|怠速时间|0-30平均加速度|0-40平均加速度|30-40间平均速度|最大车速--40的平均减速度|20-30间平均速度|0-40间平均速度|40-50间平均速度 |
f_basic_CCBC(r_fileName,maxSpeed,averageSpeed,maxAcceleratedSpeed,averageAccSpeed,minAcceleratedSpeed,averageDecSpeed,stopTime_num*10,average030AccSpd,average040AccSpd,average040DecSpd,averageSpeed2030,averageSpeed3040,average4070DecSpd,averageSpeed040,averageSpeed4050,driveTime);
end  %% f_speed_analysis(r_excelData)

