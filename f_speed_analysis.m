function f_speed_analysis(r_fileName,r_excelData)
%r_excelData ���յ����ٶȵ�����
%   Detailed explanation goes here
path=pwd;
i = find('.'==r_fileName);
imname = r_fileName(1:i-1); %% imnameΪ������׺�ļ����� 

samplingTime = 10; %%����ʱ����
dataSize = size(r_excelData);%%���ݵĸ��� ����=dataSize(1) ����=dataSize(2)
maxSpeed = max(r_excelData(:,1));   %%�����
averageSpeed = mean(r_excelData(:,1));%%ƽ������
%% ���ٷֶ�ռ��
[sortVelocity,index] = sort(r_excelData(:,1)); %% ��������--����
speed_num =  zeros(9,1);  % ����ռ�ȸ���
stopTime_num = 0; %%����ʱ�����
for i=1:dataSize(1)
    if sortVelocity(i,1)<10
        if sortVelocity(i,1) <0.04 %%����С��0.04��Ϊ����=0��
            stopTime_num =stopTime_num+1 ; %%���ڼ��㵡��ʱ��
        else
            speed_num(1,1) = speed_num(1,1)+1; %% ȥ���ٶȵ��ٺ������
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


%% ���ٶȼ���
maxAcceleratedSpeed = max(r_excelData(:,5));   %%�����ٶ�
minAcceleratedSpeed = min(r_excelData(:,5));   %%��С���ٶȣ������ٶȣ�
% averageAcceleratedSpeed = mean(r_excelData(:,5));%%ƽ�����ٶ�
%% ����ٶȷֶ�ռ��
[sortAcceleratedSpeed,a_index] = sort(r_excelData(:,5)); %% ��������--����
acceleratedSpeed_num =  zeros(10,1);  % ���ٶȣ����ٶ�/���ٶȣ�ռ�ȸ���
for i=1:dataSize(1)
    if(sortAcceleratedSpeed(i,1)<-2.0) %%�����ٶȣ����ٶȣ�
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

negative = sum(sortAcceleratedSpeed(:,1)<0); %%���ٶȸ���
positive = sum(sortAcceleratedSpeed(:,1)>0);  %%���ٶȸ���
zeroo = sum(sortAcceleratedSpeed(:,1)==0);  %%���ٶ�=0�ĸ���
averageDecSpeed =mean(sortAcceleratedSpeed(1:positive)); %%ƽ�����ٶ�
averageAccSpeed = mean(sortAcceleratedSpeed(positive+zeroo:positive+zeroo+negative)); %%ƽ�����ٶ�
%% ��ʻʱ��
driveTime = dataSize(1)*samplingTime; %%����ʱ����*���ݸ���=��ʻʱ��
%% ��ʻ���� 
driveDistance = r_excelData(dataSize(1),2)-r_excelData(1,2); %%����ʱ�ۼ����-��ʼʱ�ۼ����
%% ����ʱ��
stopTime = samplingTime*stopTime_num; %%ʱ�����0�ĸ���*�ɼ�ʱ����


%% ������ʻ
constantSpeed_Table = zeros(dataSize(1),3); %%��¼���ٵ�ʱ�䣬�ٶ�ֵ  ��ʱ��|����ʱ��|�ٶ�ֵ��
constantSpeed_Flah = 0;
for i=2:dataSize(1)-2
    if (constantSpeed_Flah == 0)&&(abs(r_excelData(i-1,1)-r_excelData(i,1))<1)&&(abs(r_excelData(i+1,1)-r_excelData(i,1))<1)
        constantSpeed_Flah = 1; %%������������ֵ����1km/h����Ϊ����������ʻ���ٶ�ֵΪr_excelData(i,1)��                                                                                                                                            ���ټ���
        constantSpeed = r_excelData(i,1);
        constantSpeed_num = 3;
        constantSpeed_Table(i-1,1)=1;
        constantSpeed_Table(i,1)=1;
        constantSpeed_Table(i+1,1)=1;%%��¼����ʱ��
    end
    if (constantSpeed_Flah == 1) &&(abs(r_excelData(i+2,1)-constantSpeed)<1)
        constantSpeed_num = constantSpeed_num+1; 
        constantSpeed_Table(i+2,1)=1;%%��¼����ʱ��
        constantSpeed_Table(i+2,2)=constantSpeed_num;%%����ʱ��
        if constantSpeed <1  %%��Ϊ�����0.04���ٶȣ���ʱ��Ϊ�ٶ�Ϊ0
            constantSpeed = 0;
        end
        constantSpeed_Table(i+2,3)=constantSpeed; %%�����ٶ�
    else
        constantSpeed_Flah = 0;
        constantSpeed_num = 0;
        continue;
    end 
end
%% ���ٶȷֶ�
temp_table=zeros(dataSize(1),12); %% 0-15 | 0-30 | 0-50 | 0-70 | 40-70 |50-70  (���ٶ�|���ٶ�)
for i=1:dataSize(1)
    if (r_excelData(i,1)>0) && (r_excelData(i,1)<15) %% 0-15
        if(r_excelData(i,5) >0) %%���ٶ�>0
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

speed015AccSpd_num=sum(temp_table(:,1)>0); %% �ٶ�0-15km/h����ٶȸ���
average015AccSpd = sum(temp_table(:,1))/speed015AccSpd_num; %% �ٶ�0-15km/h��ƽ�����ٶ�
average015DecSpd= sum(temp_table(:,2))/sum(temp_table(:,2)<0); %% �ٶ�0-15km/h��ƽ�����ٶ�
average030AccSpd = sum(temp_table(:,3))/sum(temp_table(:,3)>0); %% �ٶ�0-30km/h��ƽ�����ٶ�
average030DecSpd = sum(temp_table(:,4))/sum(temp_table(:,4)<0); %% �ٶ�0-30km/h��ƽ�����ٶ�
average040AccSpd = sum(temp_table(:,5))/sum(temp_table(:,5)>0); %% �ٶ�0-40km/h��ƽ�����ٶ�
average040DecSpd = sum(temp_table(:,6))/sum(temp_table(:,6)<0); %% �ٶ�0-40km/h��ƽ�����ٶ�
average050AccSpd = sum(temp_table(:,7))/sum(temp_table(:,7)>0); %% �ٶ�0-50km/h��ƽ�����ٶ�
average050DecSpd = sum(temp_table(:,8))/sum(temp_table(:,8)<0); %% �ٶ�0-50km/h��ƽ�����ٶ�
average070AccSpd = sum(temp_table(:,9))/sum(temp_table(:,9)>0); %% �ٶ�0-70km/h��ƽ�����ٶ�
average070DecSpd = sum(temp_table(:,10))/sum(temp_table(:,10)<0); %% �ٶ�0-70km/h��ƽ�����ٶ�
average4070AccSpd = sum(temp_table(:,11))/sum(temp_table(:,11)>0); %% �ٶ�40-70km/h��ƽ�����ٶ�
average4070DecSpd = sum(temp_table(:,12))/sum(temp_table(:,12)<0); %% �ٶ�40-70km/h��ƽ�����ٶ�
%% 0-30��ƽ���ٶ�  �ֶ�ƽ���ٶ�   30-40|40-50|20-30|0-40|20-30
averageSpeedTemp_table=zeros(dataSize(1),12); %% 
for i=1:dataSize(1)
    if(r_excelData(i,1)>20) && (r_excelData(i,1)<30) %% 0-30
        averageSpeedTemp_table(i,3) = r_excelData(i,1);
    end 
end %% 30-40��ƽ���ٶ�
% averageSpeed2030 = sum(averageSpeedTemp_table(:,3))/sum(averageSpeedTemp_table(:,3)>0); %%0-30��ƽ���ٶ�
%% 0-40��ƽ���ٶ�  �ֶ�ƽ���ٶ�   30-40|40-50|0-30|0-40
for i=1:dataSize(1)
    if(r_excelData(i,1)>0.02) && (r_excelData(i,1)<40) %% 0-30
        averageSpeedTemp_table(i,4) = r_excelData(i,1);
    end 
end %% 30-40��ƽ���ٶ�

%% 30-40��ƽ���ٶ�  �ֶ�ƽ���ٶ�   30-40|40-50|
% averageSpeedTemp_table=zeros(dataSize(1),12); %% 30-40
for i=1:dataSize(1)
    if(r_excelData(i,1)>30) && (r_excelData(i,1)<40) %% 0-70
        averageSpeedTemp_table(i,1) = r_excelData(i,1);
    end 
end %% 30-40��ƽ���ٶ�
% averageSpeed3040 = sum(averageSpeedTemp_table(:,1))/sum(averageSpeedTemp_table(:,1)>0); %%30-40��ƽ���ٶ�
%% 40-50��ƽ���ٶ�  �ֶ�ƽ���ٶ�
for i=1:dataSize(1)
    if(r_excelData(i,1)>40) && (r_excelData(i,1)<50) %% 0-70
        averageSpeedTemp_table(i,2) = r_excelData(i,1);
    end 
end %% 30-40��ƽ���ٶ�
averageSpeed3040 = sum(averageSpeedTemp_table(:,1))/sum(averageSpeedTemp_table(:,1)>0); %%30-40��ƽ���ٶ�
averageSpeed4050 = sum(averageSpeedTemp_table(:,2))/sum(averageSpeedTemp_table(:,2)>0); %%40-50��ƽ���ٶ�
averageSpeed2030 = sum(averageSpeedTemp_table(:,3))/sum(averageSpeedTemp_table(:,3)>0); %%0-30��ƽ���ٶ�
averageSpeed040 = sum(averageSpeedTemp_table(:,4))/sum(averageSpeedTemp_table(:,4)>0); %%0-30��ƽ���ٶ�
%% ����ļ�����Ӧ�ļ���  ���������ĸ��ļ�������
outFile = imname;
if ~exist(outFile)   %% ���û��output�ļ��У�
%      rmdir (outFile,'s'); %%ɾ���ļ���
    mkdir(outFile);%% ����һ��Output�ļ���
end
cd(fullfile(path,outFile)); %%����outputĿ¼

xlswrite('���ٶȷֶ�', temp_table, 'sheet1','A1');                %%���
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


%% �ٶȷֶ�--ÿ���ٶ�����ĸ���
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

sudugeshu = zeros(1,7);  %% ͳ�Ƹ��ε����ݸ���
sudugeshu(1,1)=nnz(speedTemp_table(:,1));
sudugeshu(1,2)=nnz(speedTemp_table(:,2));
sudugeshu(1,3)=nnz(speedTemp_table(:,3));
sudugeshu(1,4)=nnz(speedTemp_table(:,4));
sudugeshu(1,5)=nnz(speedTemp_table(:,5));
sudugeshu(1,6)=nnz(speedTemp_table(:,6));
sudugeshu(1,7)=nnz(speedTemp_table(:,7));

%% ����ļ�����Ӧ�ļ���  ���������ĸ��ļ�������
outFile = imname;
if ~exist(outFile')   %% ���û��output�ļ��У�
%      rmdir (outFile,'s'); %%ɾ���ļ���
    mkdir(outFile);%% ����һ��Output�ļ���
end
cd(fullfile(path,outFile)); %%����outputĿ¼
%% �ٶȷֶ�
xlswrite('�ٶȷֶ�', speedTemp_table, 'sheet1','A1');                %%�ٶȷֶ�
%% ����ͳ�Ʊ�
xlswrite('����ͳ�Ʊ�', constantSpeed_Table, 'sheet1','A1');                %%����ͳ�Ʊ�
%% word ����
cd ..
path=pwd; %%��ȡ��ǰ·��

%% ����ļ�����Ӧ�ļ���  ���������ĸ��ļ�������
%% ����WORD
outFile = imname;
if ~exist(imname)   %% ���û��output�ļ��У�
%      rmdir (outFile,'s'); %%ɾ���ļ���
    mkdir(imname);%% ����һ��Output�ļ���
end
cd(fullfile(path,imname)); %%����outputĿ¼
i = find('.'==r_fileName);
imname = r_fileName(1:i-1); %% imnameΪ������׺�ļ����� 
disp(strcat('���ڴ���',imname));
disp('���Ժ�......');
string = strcat(imname,'���ݷ�������'); %%��ɴ�excle�ļ�����podu�ļ���
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
    document = invoke(documents,'Open',file_name);% ��Excel�ļ�������������档
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
%% ҳ������
document.PageSetup.TopMargin = 60;
document.PageSetup.BottomMargin = 50;
document.PageSetup.LeftMargin = 60;
document.PageSetup.RightMargin = 60;
set(content, 'Start',0);
set(content, 'Text',string);
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
% selection.Font.Size=50;
rr=document.Range(0,length(string));%ѡ���ı�
rr.Font.Size=20;%�����ı�����
%rr.Font.Bold=4;%�����ı����� �Ӵ� 
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.MoveDown;
selection.TypeParagraph;

%% ��� ˵��
selection.MoveDown;
selection.TypeParagraph;
set(paragraphformat, 'Alignment','wdAlignParagraphJustify');
set(selection, 'Text','1. �����ռ���������������ͳ�Ʊ��������ʾ��');
selection.Font.Size=10;
selection.MoveDown;
selection.TypeParagraph;
%% �����1
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
% selection.TypeParagraph;
set(selection, 'Text','��2�� ���ٷֶ�ռ��');
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
DTI.Cell(1,1).Range.Text = '��Ŀ';%����Ҫ����
DTI.Cell(1,2).Range.Text = 'ֵ';
DTI.Cell(2,1).Range.Text = '����ʱ�� s';%����Ҫ����
DTI.Cell(3,1).Range.Text = '���Ծ��� km';
DTI.Cell(4,1).Range.Text = 'ƽ������ km/h';
DTI.Cell(5,1).Range.Text = '����� km/h';
DTI.Cell(6,1).Range.Text = '��С���ٶ� m/s^2';
DTI.Cell(7,1).Range.Text = '�����ٶ� m/s^2';
DTI.Cell(8,1).Range.Text = '����ʱ�� s';
DTI.Cell(2,2).Range.Text = num2str(driveTime);
DTI.Cell(3,2).Range.Text = num2str(driveDistance);
DTI.Cell(4,2).Range.Text = num2str(averageSpeed);
DTI.Cell(5,2).Range.Text = num2str(maxSpeed);
DTI.Cell(6,2).Range.Text = num2str(minAcceleratedSpeed);
DTI.Cell(7,2).Range.Text = num2str(maxAcceleratedSpeed);
DTI.Cell(8,2).Range.Text = num2str(stopTime_num*samplingTime);

%% �����2 
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
% selection.TypeParagraph;
set(selection, 'Text','��2�� ���ٷֶ�ռ��');
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

DTI2.Cell(1,1).Range.Text = '���';%����Ҫ����
DTI2.Cell(2,1).Range.Text = '��߳���(km/h)';
DTI2.Cell(3,1).Range.Text = 'ƽ������(km/h)';
DTI2.Cell(4,1).Range.Text = '����ռ��';
DTI2.Cell(4,2).Range.Text = '���� (km/h)';
DTI2.Cell(5,2).Range.Text = '0-10(km/h)';
DTI2.Cell(6,2).Range.Text = '10-20(km/h)';
DTI2.Cell(7,2).Range.Text = '20-30(km/h)';
DTI2.Cell(8,2).Range.Text = '30-40(km/h)';
DTI2.Cell(9,2).Range.Text = '40-50(km/h)';
DTI2.Cell(10,2).Range.Text = '50-60(km/h)';
DTI2.Cell(11,2).Range.Text = '60-70(km/h)';
DTI2.Cell(12,2).Range.Text = '70-80(km/h)';
DTI2.Cell(13,2).Range.Text = '80-90(km/h)';

DTI2.Cell(1,3).Range.Text = '��ֵ';%����Ҫ����
DTI2.Cell(2,3).Range.Text = num2str(maxSpeed );%�ɼ�ʱ��
DTI2.Cell(3,3).Range.Text = num2str(averageSpeed);%��ʻ����

DTI2.Cell(4,3).Range.Text = num2str(sprintf('%2.2f%%', (stopTime_num/dataSize(1))*100));%����ռ��  
DTI2.Cell(5,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(1,1)/dataSize(1))*100));%����ռ��  
DTI2.Cell(6,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(2,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(7,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(3,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(8,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(4,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(9,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(5,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(10,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(6,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(11,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(7,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(12,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(8,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(13,3).Range.Text = num2str(sprintf('%2.2f%%', (speed_num(9,1)/dataSize(1))*100));%����ռ��

%% �ϲ���Ԫ��
DTI2.Cell(1, 1).Merge(DTI2.Cell(1, 2));
DTI2.Cell(2, 1).Merge(DTI2.Cell(2, 2));
DTI2.Cell(3, 1).Merge(DTI2.Cell(3, 2));
DTI2.Cell(4, 1).Merge(DTI2.Cell(13, 1));

%% �����3 
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
% selection.TypeParagraph;
set(selection, 'Text','��3�� ���ٶȷֶ�ռ��');
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
DTI2.Cell(1,1).Range.Text = '���';%����Ҫ����
DTI2.Cell(2,1).Range.Text = '�����ٶ� m/s^2';
DTI2.Cell(3,1).Range.Text = '��С���ٶ� m/s^2';
DTI2.Cell(4,1).Range.Text = '���ٶ�ռ��';
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

DTI2.Cell(1,3).Range.Text = '��ֵ';%����Ҫ����
DTI2.Cell(2,3).Range.Text = num2str(maxAcceleratedSpeed);%�ɼ�ʱ��
DTI2.Cell(3,3).Range.Text = num2str(minAcceleratedSpeed);%��ʻ����

DTI2.Cell(4,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(10,1)/dataSize(1))*100));%����ռ��  
DTI2.Cell(5,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(9,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(6,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(8,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(7,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(7,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(8,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(6,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(9,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(5,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(10,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(4,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(11,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(3,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(12,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(2,1)/dataSize(1))*100));%����ռ��
DTI2.Cell(13,3).Range.Text = num2str(sprintf('%2.2f%%', (acceleratedSpeed_num(1,1)/dataSize(1))*100));%����ռ��

%% �ϲ���Ԫ��
DTI2.Cell(1, 1).Merge(DTI2.Cell(1, 2));
DTI2.Cell(2, 1).Merge(DTI2.Cell(2, 2));
DTI2.Cell(3, 1).Merge(DTI2.Cell(3, 2));
DTI2.Cell(4, 1).Merge(DTI2.Cell(13, 1));

%% �����4 
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
% selection.TypeParagraph;
set(selection, 'Text','��4�� ��·����Ҫ������');
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
DTI2.Cell(1,1).Range.Text = '���';%����Ҫ����
DTI2.Cell(2,1).Range.Text = '����ٶ� km/h';
DTI2.Cell(3,1).Range.Text = 'ƽ���ٶ� km/h';
DTI2.Cell(4,1).Range.Text = '�����ٶ� m/s^2';
DTI2.Cell(5,1).Range.Text = 'ƽ�����ٶ� m/s^2 ';
DTI2.Cell(6,1).Range.Text = '�����ٶ� m/s^2';
DTI2.Cell(7,1).Range.Text = 'ƽ�����ٶ� m/s^2';
DTI2.Cell(8,1).Range.Text = '����ʱ�� s';
DTI2.Cell(9,1).Range.Text = '0-15ƽ�����ٶ�';
DTI2.Cell(10,1).Range.Text = '0-40ƽ�����ٶ�';
DTI2.Cell(11,1).Range.Text = '0-40ƽ�����ٶ�';
DTI2.Cell(12,1).Range.Text = '0-40��ƽ���ٶ�';
DTI2.Cell(13,1).Range.Text = '20-30��ƽ���ٶ�';
DTI2.Cell(14,1).Range.Text = '30-40��ƽ���ٶ�';
DTI2.Cell(15,1).Range.Text = '40-50��ƽ���ٶ�';
DTI2.Cell(16,1).Range.Text = '�����-40���ƽ�����ٶ�';

DTI2.Cell(1,3).Range.Text = '��ֵ';%����Ҫ����
DTI2.Cell(2,3).Range.Text = num2str(maxSpeed);%����ٶ�
DTI2.Cell(3,3).Range.Text = num2str(averageSpeed);%ƽ���ٶ�
DTI2.Cell(4,3).Range.Text = num2str(maxAcceleratedSpeed);%�����ٶ�  
DTI2.Cell(5,3).Range.Text = num2str(averageAccSpeed);%ƽ�����ٶ�
DTI2.Cell(6,3).Range.Text = num2str(minAcceleratedSpeed);%�����ٶ�
DTI2.Cell(7,3).Range.Text = num2str(averageDecSpeed);%ƽ�����ٶ�
DTI2.Cell(8,3).Range.Text = num2str(stopTime_num*10);%����ʱ��
DTI2.Cell(9,3).Range.Text = num2str(average015AccSpd);%0-15ƽ�����ٶ�
DTI2.Cell(10,3).Range.Text = num2str(average040AccSpd);%0-40ƽ�����ٶ�
DTI2.Cell(11,3).Range.Text = num2str(average040DecSpd);%30-40��ƽ�����ٶ�
DTI2.Cell(12,3).Range.Text = num2str(averageSpeed040);%0-40��ƽ���ٶ�
DTI2.Cell(13,3).Range.Text = num2str(averageSpeed2030);%20-30��ƽ���ٶ�
DTI2.Cell(14,3).Range.Text = num2str(averageSpeed3040);%30-40��ƽ���ٶ�
DTI2.Cell(15,3).Range.Text = num2str(averageSpeed4050);%40-50��ƽ���ٶ�
DTI2.Cell(16,3).Range.Text = num2str(average4070DecSpd);%�����-40���ƽ�����ٶ�



%% ����ͼ1 ��������
figure;
plot(r_excelData(:,1),'r-');%%����
hold on;
grid on;%%��ʾ������
legend('ʱ�䳵������');
title('ʱ�䳵������');
xlabel('ʱ�� s');
ylabel('���� km/h');

%% ��ͼ��ճ������ǰ�ĵ���
print -dbitmap %% ��������ͼ
selection.Range.Paste;
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.MoveDown;
%% ͼ1 ˵��
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
selection.TypeParagraph;
set(selection, 'Text','ͼ1�� ʱ�䳵������');
selection.Font.Size=8;
selection.MoveDown;
selection.TypeParagraph;
close;                  % �ر�Figure
%% ����ͼ2 ���ٶ�����
figure;
xuhao = linspace(1,dataSize(1),dataSize(1));
plot(xuhao',r_excelData(:,5),'r.');%%���ٶ�
hold on;
grid on; %% ��ʾ������
legend('ʱ����ٶ�����');
title('ʱ����ٶ�����');
xlabel('ʱ�� s');
ylabel('���� m/s^2');
%% ��ͼ��ճ������ǰ�ĵ���
print -dbitmap %% ��������ͼ
selection.Range.Paste;
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.MoveDown;
%% ͼ2 ˵��
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
selection.TypeParagraph;
set(selection, 'Text','ͼ2�� ʱ����ٶ�����');
selection.Font.Size=8;
selection.MoveDown;
selection.TypeParagraph;
close;                  % �ر�Figure

%% ����ͼ3 �ٶ�-���ٶ�����
figure;
plot(sortVelocity(:,1),r_excelData(:,5),'r.');
hold on;
grid on; %% ��ʾ������
legend('�ٶȼ��ٶ�����');
title('�ٶȼ��ٶ�����');
xlabel('�ٶ� km/h');
ylabel('���� m/s^2');
%% ��ͼ��ճ������ǰ�ĵ���
print -dbitmap %% ��������ͼ
selection.Range.Paste;
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.MoveDown;
%% ͼ3 ˵��
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
selection.TypeParagraph;
set(selection, 'Text','ͼ3�� �ٶȼ��ٶ�����');
selection.Font.Size=8;
selection.MoveDown;
selection.TypeParagraph;
close;                  % �ر�Figure
%% ����ͼ4 �ٶȷֶθ���ͳ��
figure;
bar(sudugeshu,'stacked');  %%��״ͼ��ʾ���ٶȶθ���
set(gca,'XTickLabel',{'0-10','10-20','20-30','30-40','40-50','50-60','60-70'});
hold on;
% grid on; %% ��ʾ������
legend('�ٶȷֶ�ͳ��');
title('�ٶȷֶ�ͳ����״ͼ');
xlabel('�ٶ����� km/h');
ylabel('���� ��');
%% ��ͼ��ճ������ǰ�ĵ���
print -dbitmap %% ��������ͼ
selection.Range.Paste;
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.MoveDown;
%% ͼ4 ˵��
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
selection.TypeParagraph;
set(selection, 'Text','ͼ3�� �ٶȼ��ٶ�����');
selection.Font.Size=8;
selection.MoveDown;
selection.TypeParagraph;
close;                  % �ر�Figure


%% �����ĵ�
Document.ActiveWindow.ActivePane.View.Type = 'wdPrintView';
document = invoke(document,'SaveAs',file_name); % �����ĵ�
Word.Quit; % �ر��ĵ�
disp(strcat(imname,'�ĵ�������ϣ����ڵ�ǰ�ļ����в鿴��'));%% ��ʾ��Ϣxxxx�ĵ��������
system('taskkill /F /IM WINWORD.EXE');% ����excel����
cd ..       %%�˳�outputĿ¼


%%          �ļ���|����ٶ�|ƽ���ٶ�|�����ٶ�|ƽ�����ٶ�|�����ٶ�|ƽ�����ٶ�|����ʱ��|0-30ƽ�����ٶ�|0-40ƽ�����ٶ�|30-40��ƽ���ٶ�|�����--40��ƽ�����ٶ�|20-30��ƽ���ٶ�|0-40��ƽ���ٶ�|40-50��ƽ���ٶ� |
f_basic_CCBC(r_fileName,maxSpeed,averageSpeed,maxAcceleratedSpeed,averageAccSpeed,minAcceleratedSpeed,averageDecSpeed,stopTime_num*10,average030AccSpd,average040AccSpd,average040DecSpd,averageSpeed2030,averageSpeed3040,average4070DecSpd,averageSpeed040,averageSpeed4050,driveTime);
end  %% f_speed_analysis(r_excelData)

