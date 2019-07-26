%% 城区基本循环工况
%%                  文件名 |  最大速度|    平均速度|    最大加速度|         平均加速度|        最大减速度|        平均减速度|        怠速时间|      0-30平均加速度|  0-40平均加速度|  0-40平均减速度| 20-30间平均速度| 30-40间平均速度| 最大车速-40的平均减速度|0-40间平均速度|40-50间平均速度|测试时间
function f_basic_CCBC(r_fileName,r_maxSpeed,r_averageSpeed,r_maxAcceleratedSpeed,r_averageAccSpeed,r_minAcceleratedSpeed,r_averageDecSpeed,r_stopTime_num,r_average030AccSpd,r_average040AccSpd,r_average040DecSpd,r_averageSpeed2030,r_averageSpeed3040,r_average4070DecSpd,r_averageSpeed040,r_averageSpeed4050 ,r_driveTime )
kn=zeros(26,1);
bn=zeros(26,1);
tns=zeros(27,1);
tn=zeros(26,1);
% kn=[0 1.0286 0 -1.1311 0 0.49614 0.34316 0 -0.28404 0 0.49614 0.34316  0.28827 0 -0.33293  0 -1.1311 0,0.34316,0,-0.28404,0,0.34316,0,-1.1311,0]';
kn(2)=r_maxAcceleratedSpeed; %%最大加速度
kn(4)=r_minAcceleratedSpeed; %%最大减速度
kn(6)=r_average030AccSpd; %%0-30平均加速度
kn(7)=r_average040AccSpd; %%0-40平均加速度
kn(9)=r_averageDecSpeed; %%平均减速度
kn(11)=r_average030AccSpd; %%0-30平均加速度
kn(12)=r_average040AccSpd; %%0-40平均加速度
kn(13)=r_averageAccSpeed; %%平均加速度
kn(15)=r_average4070DecSpd; %% 最大车速-40的平均减速度
kn(17)= r_minAcceleratedSpeed; %%最大减速度
kn(19)=r_average040AccSpd; %%0-40平均加速度
kn(21)=r_average040DecSpd; %%0-40平均减速度
kn(23)=r_average040AccSpd; %%0-40平均加速度
kn(25)=r_minAcceleratedSpeed; %%最大减速度

speed12=r_averageSpeed/3.6;%%平均速度
speed13=r_averageSpeed3040/3.6; %%30-40间的平均速度
speed16=r_averageSpeed4050/3.6; %%40-50间平均速度


bn(1,1)=0;
bn(3,1)=r_averageSpeed/3.6; %%平均速度
bn(5,1)=0;
bn(8,1)=r_averageSpeed3040/3.6; %%30-40间的平均速度
bn(10,1)=0;
bn(14,1)=r_maxSpeed/3.6; %%最大速度
bn(16,1)=speed16;
bn(18,1)=0;
% bn(20)=r_averageSpeed4050/3.6; %%40-50间平均速度
% bn(22)=r_averageSpeed040/3.6;%%0-40间平均速度
% bn(24)=r_averageSpeed3040/3.6; %%30-40间的平均速度

bn(20)=r_averageSpeed2030/3.6; %%40-50间平均速度
bn(22)=10/3.6;%%0-40间平均速度
bn(24)=r_averageSpeed2030/3.6; %%30-40间的平均速度
bn(26)=0;



tns(1,1)=0;
tn(1,1)=r_stopTime_num/5/6;
tn(3,1)=16;
tn(5,1)=r_stopTime_num/5/6;
tn(6,1)=6;
tn(8)=20;
tn(10)=r_stopTime_num/5/6;
tn(14)=10;
tn(16)=15;
tn(18)=r_stopTime_num/5/6;
tn(20)=13;
tn(22)=20;
tn(24)=10;
tn(26)=r_stopTime_num/5/6;

tns(2,1)=tns(1,1)+tn(1,1);
bn(1,1)=0;
bn(2,1)=0-(kn(2,1)*tns(2,1));  %%b2
tns(3,1)=(bn(3,1)-bn(2,1))/kn(2,1);
tn(2,1)=tns(3,1)-tns(2,1); 
%% y3=k3*x+b3;
tns(4,1)=tns(3,1)+tn(3,1);
bn(4,1)=bn(3,1)-kn(4,1)*tns(4,1);
%% y4=k4*x+b4;
tns(5,1)=0-(bn(4,1)/kn(4,1));
tn(4)=tns(5)-tns(4);
tns(6,1)=tns(5,1)+tn(5,1);
%% b6
bn(6)=0-kn(6,1)*tns(6,1);
tns(7,1)=tns(6,1)+tn(6,1);
y6=kn(6)*tns(7)+bn(6);
bn(7)=y6-kn(7)*tns(7);
tns(8)=(bn(8)-bn(7))/kn(7);
tn(7)=tns(8)-tns(7);
tns(9)=tns(8)+tn(8);
% y9s=bn(8);
bn(9)=bn(8)-kn(9)*tns(9);
tns(10)=0-bn(9)/kn(9);
tn(9)=tns(10)-tns(9);%%tn
tns(11)=tns(10)+tn(10);
bn(11)=0-kn(11)*tns(11);
tns(12)=(speed12-bn(11))/kn(11);
tn(11)=tns(12)-tns(11);%%tn
bn(12)=speed12-kn(12)*tns(12);
tns(13)=(speed13-bn(12))/kn(12);
tn(12)=tns(13)-tns(12);%%tn
bn(13)=speed13-kn(13)*tns(13);
tns(14)=(bn(14)-bn(13))/kn(13);
tn(13)=tns(14)-tns(13);%%tn
tns(15)=tns(14)+tn(14);
bn(15)=bn(14)-kn(15)*tns(15);
tns(16)=(speed16-bn(15))/kn(15);
tn(15)=tns(16)-tns(15);%%tn
tns(17)=tns(16)+tn(16);
bn(17)=speed16-kn(17)*tns(17);
tns(18)=0-bn(17)/kn(17);
tn(17)=tns(18)-tns(17); %%tn
tns(19)=tns(18)+tn(18);
bn(19)=0-kn(19)*tns(19);
tns(20)=(bn(20)-bn(19))/kn(19);
tn(19)=tns(20)-tns(19);%%tn
tns(21)=tns(20)+tn(20);
bn(21)=bn(20)-kn(21)*tns(21);
tns(22)=(bn(22)-bn(21))/kn(21);
tn(21)=tns(22)-tns(21);%%tn
tns(23)=tns(22)+tn(22);
bn(23)=bn(22)-kn(23)*tns(23);
tns(24)=(bn(24)-bn(23))/kn(23);
tn(23)=tns(24)-tns(23);%%tn
tns(25)=tns(24)+tn(24);
bn(25)=bn(24)-kn(25)*tns(25);
tns(26)=0-bn(25)/kn(25);
tn(25)=tns(26)-tns(25);%%tn
tns(27)=tns(26)+tn(26);


% x=0:320;
% y=3.6*(kn(1)*x+bn(1)).*(x>0 & x<=tns(2))+3.6*(kn(2)*x+bn(2)).*(x>tns(2) & x<=tns(3))+3.6*(kn(3)*x+bn(3)).*(x>tns(3) & x<=tns(4))+3.6*(kn(4)*x+bn(4)).*(x>tns(4) & x<=tns(5))+3.6*(kn(5)*x+bn(5)).*(x>tns(5) & x<=tns(6))+3.6*(kn(6)*x+bn(6)).*(x>tns(6) & x<=tns(7)) ...
% +3.6*(kn(7)*x+bn(7)).*(x>tns(7) & x<=tns(8))+3.6*(kn(8)*x+bn(8)).*(x>tns(8) & x<=tns(9))+3.6*(kn(9)*x+bn(9)).*(x>tns(9) & x<=tns(10))+3.6*(kn(10)*x+bn(10)).*(x>tns(10) & x<=tns(11))+3.6*(kn(11)*x+bn(11)).*(x>tns(11) & x<=tns(12))+3.6*(kn(12)*x+bn(12)).*(x>tns(12) & x<=tns(13)) ...
% +3.6*(kn(13)*x+bn(13)).*(x>tns(13) & x<=tns(14))+3.6*(kn(14)*x+bn(14)).*(x>tns(14) & x<=tns(15))+3.6*(kn(15)*x+bn(15)).*(x>tns(15) & x<=tns(16))+3.6*(kn(16)*x+bn(16)).*(x>tns(16) & x<=tns(17))+3.6*(kn(17)*x+bn(17)).*(x>tns(17) & x<=tns(18))+3.6*(kn(18)*x+bn(18)).*(x>tns(18) & x<=tns(19));


%% 生成WORD报告
path=pwd;
i = find('.'==r_fileName);
imname = r_fileName(1:i-1); %% imname为不带后缀文件名称 

outFile = imname;
if ~exist(imname)   %% 如果没有与文件名相对应的文件夹
    mkdir(imname);%% 创建一个与文件名相对应的文件夹
end
cd(fullfile(path,imname)); %%进入output目录
i = find('.'==r_fileName);
imname = r_fileName(1:i-1); %% imname为不带后缀文件名称 
disp(strcat('正在处理',imname));
disp('请稍候......');
string = strcat(imname,'市区循环工况报告'); %%组成带excle文件名的市区循环工况报告
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
    document = invoke(documents,'Open',file_name);% 以相应文件名保存分析报告。
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
row = 27;%%行数
column = 8; %%列数
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
set(selection, 'Text','表1： 基本市区循环');
selection.Font.Size=8;
selection.MoveDown;
Tables=document.Tables.Add(selection.Range,row,column);
DTI=document.Tables.Item(1);
DTI.Borders.OutsideLineStyle='wdLineStyleSingle';
DTI.Borders.OutsideLineWidth='wdLineWidth150pt';
DTI.Borders.InsideLineStyle='wdLineStyleSingle';
DTI.Borders.InsideLineWidth='wdLineWidth150pt';
DTI.Rows.Alignment='wdAlignRowCenter';
column_width=[60.575,60.7736,60.575,70.7736,80.575,70.7736,70.575,70.7736];
row_height =zeros(row,1);  %% 行高
for i=1:row     
    row_height(i)=20.5849;
end
for i=1:column
DTI.Columns.Item(i).Width=column_width(i);
end
for i=1:row
DTI.Rows.Item(i).Height =row_height(i);
end
for i=1:row
for j=1:column
      DTI.Cell(i,j).VerticalAlignment='wdCellAlignVerticalCenter';
end
end
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.TypeParagraph;
DTI.Cell(1,1).Range.Text = '运转次序';%不需要更改
DTI.Cell(1,2).Range.Text = '操作状态';
DTI.Cell(1,3).Range.Text = '工况序号';%不需要更改
DTI.Cell(1,4).Range.Text = '加速度 m/s^2';
DTI.Cell(1,5).Range.Text = '速度 km/h';%不需要更改
DTI.Cell(1,6).Range.Text = '操作时间 s';
DTI.Cell(1,7).Range.Text = '工况时间';%不需要更改
DTI.Cell(1,8).Range.Text = '累计时间';
xuhao = linspace(1,row-1,row-1);
do_state =["停车","加速","等速","减速","停车","加速","加速","等速","减速","停车","加速","加速","加速","等速","减速","等速","减速","停车","加速","等速","减速","等速","加速","等速","减速","停车"];
% do_state =['停车','加速','等速','减速','停车','加速','加速','等速','减速','停车','加速','加速','加速','等速','减速','等速','减速','停车','加速','等速','减速','等速','加速','等速','减速','停车'];
for i=2:row
    DTI.Cell(i,1).Range.Text = num2str(xuhao(i-1)); %%运转次序
    DTI.Cell(i,2).Range.Text = do_state(i-1);%%操作状态
    DTI.Cell(i,4).Range.Text = num2str(roundn(kn(i-1),-2)); %%加速度 = 斜率
    DTI.Cell(i,5).Range.Text = num2str(roundn(bn(i-1),-2)); %%速度 = bn  有的单元格需要修改，后面使用程序修改
    DTI.Cell(i,6).Range.Text = num2str(fix(tn(i-1))); %%操作时间 = tn
    DTI.Cell(i,8).Range.Text = num2str(fix(tns(i))); %%操作时间 = tns 
    
    if i==8
        DTI.Cell(7,7).Range.Text = num2str(fix(tn(6)+tn(7)));
        continue;
    end
    if i==13 || i==14
        DTI.Cell(12,7).Range.Text = num2str(fix(tn(11)+tn(12)+tn(13))); 
        continue;
    end
    DTI.Cell(i,7).Range.Text = num2str(fix(tn(i-1))); %%操作时间 = tn 有的单元格需要修改，后面使用程序修改
end 
DTI.Cell(2,3).Range.Text = '1';
DTI.Cell(3,3).Range.Text = '2';
DTI.Cell(4,3).Range.Text = '3';
DTI.Cell(5,3).Range.Text = '4';
DTI.Cell(6,3).Range.Text = '5';
DTI.Cell(7,3).Range.Text = '6';
DTI.Cell(9,3).Range.Text = '7';
DTI.Cell(10,3).Range.Text = '8';
DTI.Cell(11,3).Range.Text = '9';
DTI.Cell(12,3).Range.Text = '10';
DTI.Cell(15,3).Range.Text = '11';
DTI.Cell(16,3).Range.Text = '12';
DTI.Cell(17,3).Range.Text = '13';
DTI.Cell(18,3).Range.Text = '14';
DTI.Cell(19,3).Range.Text = '15';
DTI.Cell(20,3).Range.Text = '16';
DTI.Cell(21,3).Range.Text = '17';
DTI.Cell(22,3).Range.Text = '18';
DTI.Cell(23,3).Range.Text = '19';
DTI.Cell(24,3).Range.Text = '20';
DTI.Cell(25,3).Range.Text = '21';
DTI.Cell(26,3).Range.Text = '22';
DTI.Cell(27,3).Range.Text = '23';

DTI.Cell(3,5).Range.Text = strcat(num2str(roundn(bn(1)*3.6,-2)),'-',num2str(roundn(bn(3)*3.6,-2)));   %% 修改速度过渡的单元格
DTI.Cell(5,5).Range.Text = strcat(num2str(roundn(bn(3)*3.6,-2)),'-',num2str(roundn(bn(5)*3.6,-2)));
DTI.Cell(7,5).Range.Text = strcat(num2str(roundn(bn(5)*3.6,-2)),'-',num2str(roundn(bn(7)*3.6,-2)));
DTI.Cell(8,5).Range.Text = strcat(num2str(roundn(bn(6)*3.6,-2)),'-',num2str(roundn(bn(8)*3.6,-2)));
DTI.Cell(10,5).Range.Text = strcat(num2str(roundn(bn(8)*3.6,-2)),'-',num2str(roundn(bn(9)*3.6,-2)));
DTI.Cell(12,5).Range.Text = strcat(num2str(roundn(bn(10)*3.6,-2)),'-',num2str(roundn(bn(12)*3.6,-2)));
DTI.Cell(13,5).Range.Text = strcat(num2str(roundn(bn(11)*3.6,-2)),'-',num2str(roundn(bn(13)*3.6,-2)));
DTI.Cell(14,5).Range.Text = strcat(num2str(roundn(bn(12)*3.6,-2)),'-',num2str(roundn(bn(14)*3.6,-2)));
DTI.Cell(16,5).Range.Text = strcat(num2str(roundn(bn(14)*3.6,-2)),'-',num2str(roundn(bn(16)*3.6,-2)));
DTI.Cell(18,5).Range.Text = strcat(num2str(roundn(bn(16)*3.6,-2)),'-',num2str(roundn(bn(18)*3.6,-2)));
DTI.Cell(20,5).Range.Text = strcat(num2str(roundn(bn(18)*3.6,-2)),'-',num2str(roundn(bn(20)*3.6,-2)));
DTI.Cell(22,5).Range.Text = strcat(num2str(roundn(bn(20)*3.6,-2)),'-',num2str(roundn(bn(22)*3.6,-2)));
DTI.Cell(24,5).Range.Text = strcat(num2str(roundn(bn(22)*3.6,-2)),'-',num2str(roundn(bn(24)*3.6,-2)));
DTI.Cell(26,5).Range.Text = strcat(num2str(roundn(bn(24)*3.6,-2)),'-',num2str(roundn(bn(26)*3.6,-2)));

%% 合并单元格
DTI.Cell(12, 3).Merge(DTI.Cell(14, 3));
DTI.Cell(7, 3).Merge(DTI.Cell(8, 3));
DTI.Cell(12, 7).Merge(DTI.Cell(14, 7));
DTI.Cell(7, 7).Merge(DTI.Cell(8, 7));

runTime1=700;
figure;
for i=1:fix(r_driveTime/runTime1)
    x =(i-1)*runTime1 : runTime1*i;
    y=3.6*(kn(1)*(x-runTime1*(i-1))+bn(1)).*((x-runTime1*(i-1))>0 & (x-runTime1*(i-1))<=tns(2))+3.6*(kn(2)*(x-runTime1*(i-1))+bn(2)).*((x-runTime1*(i-1))>tns(2) & (x-runTime1*(i-1))<=tns(3))+3.6*(kn(3)*(x-runTime1*(i-1))+bn(3)).*((x-runTime1*(i-1))>tns(3) & (x-runTime1*(i-1))<=tns(4))+3.6*(kn(4)*(x-runTime1*(i-1))+bn(4)).*((x-runTime1*(i-1))>tns(4) & (x-runTime1*(i-1))<=tns(5))+3.6*(kn(5)*(x-runTime1*(i-1))+bn(5)).*((x-runTime1*(i-1))>tns(5) & (x-runTime1*(i-1))<=tns(6))+3.6*(kn(6)*(x-runTime1*(i-1))+bn(6)).*((x-runTime1*(i-1))>tns(6) & (x-runTime1*(i-1))<=tns(7)) ...
    +3.6*(kn(7)*(x-runTime1*(i-1))+bn(7)).*((x-runTime1*(i-1))>tns(7) & (x-runTime1*(i-1))<=tns(8))+3.6*(kn(8)*(x-runTime1*(i-1))+bn(8)).*((x-runTime1*(i-1))>tns(8) & (x-runTime1*(i-1))<=tns(9))+3.6*(kn(9)*(x-runTime1*(i-1))+bn(9)).*((x-runTime1*(i-1))>tns(9) & (x-runTime1*(i-1))<=tns(10))+3.6*(kn(10)*(x-runTime1*(i-1))+bn(10)).*((x-runTime1*(i-1))>tns(10) & (x-runTime1*(i-1))<=tns(11))+3.6*(kn(11)*(x-runTime1*(i-1))+bn(11)).*((x-runTime1*(i-1))>tns(11) & (x-runTime1*(i-1))<=tns(12))+3.6*(kn(12)*(x-runTime1*(i-1))+bn(12)).*((x-runTime1*(i-1))>tns(12) & (x-runTime1*(i-1))<=tns(13)) ...
    +3.6*(kn(13)*(x-runTime1*(i-1))+bn(13)).*((x-runTime1*(i-1))>tns(13) & (x-runTime1*(i-1))<=tns(14))+3.6*(kn(14)*(x-runTime1*(i-1))+bn(14)).*((x-runTime1*(i-1))>tns(14) & (x-runTime1*(i-1))<=tns(15))+3.6*(kn(15)*(x-runTime1*(i-1))+bn(15)).*((x-runTime1*(i-1))>tns(15) & (x-runTime1*(i-1))<=tns(16))+3.6*(kn(16)*(x-runTime1*(i-1))+bn(16)).*((x-runTime1*(i-1))>tns(16) & (x-runTime1*(i-1))<=tns(17))+3.6*(kn(17)*(x-runTime1*(i-1))+bn(17)).*((x-runTime1*(i-1))>tns(17) & (x-runTime1*(i-1))<=tns(18))+3.6*(kn(18)*(x-runTime1*(i-1))+bn(18)).*((x-runTime1*(i-1))>tns(18) & (x-runTime1*(i-1))<=tns(19)) ...
    +3.6*(kn(19)*(x-runTime1*(i-1))+bn(19)).*((x-runTime1*(i-1))>tns(19) & (x-runTime1*(i-1))<=tns(20))+3.6*(kn(20)*(x-runTime1*(i-1))+bn(20)).*((x-runTime1*(i-1))>tns(20) & (x-runTime1*(i-1))<=tns(21))+3.6*(kn(21)*(x-runTime1*(i-1))+bn(21)).*((x-runTime1*(i-1))>tns(21) & (x-runTime1*(i-1))<=tns(22))+3.6*(kn(22)*(x-runTime1*(i-1))+bn(22)).*((x-runTime1*(i-1))>tns(22) & (x-runTime1*(i-1))<=tns(23))+3.6*(kn(23)*(x-runTime1*(i-1))+bn(23)).*((x-runTime1*(i-1))>tns(23) & (x-runTime1*(i-1))<=tns(24))+3.6*(kn(24)*(x-runTime1*(i-1))+bn(24)).*((x-runTime1*(i-1))>tns(24) & (x-runTime1*(i-1))<=tns(25))+3.6*(kn(25)*(x-runTime1*(i-1))+bn(25)).*((x-runTime1*(i-1))>tns(25) & (x-runTime1*(i-1))<=tns(26));
    plot(x,y,'r-');
    hold on;
end
average_y = mean(y);

axis([0 r_driveTime+500 0 260/3.6]) %%设置坐标轴范围
legend('基本市区循环');
title('基本市区循环');
xlabel('时间 s');
ylabel('速度 km/h');
print -dbitmap %% 复制曲线图
selection.Range.Paste;
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.MoveDown;


%% 表格2
row = 11;%%行数
column = 4; %%列数
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
set(selection, 'Text','表2： 表1（续）');
selection.Font.Size=8;
selection.MoveDown;
Tables=document.Tables.Add(selection.Range,row,column);
DTI=document.Tables.Item(2);
DTI.Borders.OutsideLineStyle='wdLineStyleSingle';
DTI.Borders.OutsideLineWidth='wdLineWidth150pt';
DTI.Borders.InsideLineStyle='wdLineStyleSingle';
DTI.Borders.InsideLineWidth='wdLineWidth150pt';
DTI.Rows.Alignment='wdAlignRowCenter';
column_width=[70.575,60.7736,60.575,70.7736,80.575,70.7736,70.575,70.7736];
row_height =zeros(row,1);  %% 行高
for i=1:row    
    if i<8
        row_height(i)=20.5849;
    else
        row_height(i)=40.5849;
    end
end
for i=1:column
DTI.Columns.Item(i).Width=column_width(i);
end
for i=1:row
DTI.Rows.Item(i).Height =row_height(i);
end
for i=1:row
for j=1:column
      DTI.Cell(i,j).VerticalAlignment='wdCellAlignVerticalCenter';
end
end
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.TypeParagraph;
DTI.Cell(1,1).Range.Text = '工况统计';%不需要更改
DTI.Cell(1,2).Range.Text = '单位';
DTI.Cell(1,3).Range.Text = '数据';
DTI.Cell(1,4).Range.Text = '点总时间的百分比%';
DTI.Cell(2,1).Range.Text = '停车';
DTI.Cell(3,1).Range.Text = '加速';
DTI.Cell(4,1).Range.Text = '等速';
DTI.Cell(5,1).Range.Text = '减速';
DTI.Cell(6,1).Range.Text = '总时间';
DTI.Cell(7,1).Range.Text = '平均车速';
DTI.Cell(8,1).Range.Text = '一个基本城市循环的工作时间';
DTI.Cell(9,1).Range.Text = '一个城市循环的工作时间';
DTI.Cell(10,1).Range.Text = '一个基本城市循环的理论行驶距离';
DTI.Cell(11,1).Range.Text = '一个城市循环的理论行驶距离';

DTI.Cell(2,2).Range.Text = 's';
DTI.Cell(3,2).Range.Text = 's';
DTI.Cell(4,2).Range.Text = 's';
DTI.Cell(5,2).Range.Text = 's';
DTI.Cell(6,2).Range.Text = 's';
DTI.Cell(7,2).Range.Text = 'km/h';
DTI.Cell(8,2).Range.Text = 's';
DTI.Cell(9,2).Range.Text = 's';
DTI.Cell(10,2).Range.Text = 'm';
DTI.Cell(11,2).Range.Text = 'm';

DTI.Cell(2,3).Range.Text = num2str(fix(tn(1)+tn(5)+tn(10)+tn(18)+tn(12)+tn(26)));
DTI.Cell(3,3).Range.Text = num2str(fix(tn(2)+tn(6)+tn(7)+tn(11)+tn(12)+tn(13)+tn(19)+tn(23)));
DTI.Cell(4,3).Range.Text = num2str(fix(tn(3)+tn(8)+tn(14)+tn(16)+tn(20)+tn(22)+tn(24)+tn(23)));
DTI.Cell(5,3).Range.Text = num2str(fix(tn(4)+tn(9)+tn(15)+tn(17)+tn(21)+tn(25)));
DTI.Cell(6,3).Range.Text = num2str(fix(tns(27)));
DTI.Cell(7,3).Range.Text = num2str(mean(y));
DTI.Cell(8,3).Range.Text = num2str(fix(tns(27)));
DTI.Cell(9,3).Range.Text =num2str(mean(y));
DTI.Cell(10,3).Range.Text = num2str(average_y/3.6*fix(tns(27)));
DTI.Cell(11,3).Range.Text = num2str(r_driveTime*average_y/3.6);

DTI.Cell(2,4).Range.Text = num2str((fix(tn(1))+fix(tn(5))+fix(tn(10))+fix(tn(18))+fix(tn(26)))/sum(fix(tn(:)))*100);
DTI.Cell(3,4).Range.Text = num2str((fix(tn(2))+fix(tn(6))+fix(tn(7))+fix(tn(11))+fix(tn(12))+fix(tn(13))+fix(tn(19))+fix(tn(23)))/sum(fix(tn(:)))*100);
DTI.Cell(4,4).Range.Text = num2str((fix(tn(3))+fix(tn(8))+fix(tn(14))+fix(tn(16))+fix(tn(20))+fix(tn(22))+fix(tn(24))+fix(tn(23)))/sum(fix(tn(:)))*100);
DTI.Cell(5,4).Range.Text =num2str((fix(tn(4))+fix(tn(9))+fix(tn(15))+fix(tn(17))+fix(tn(21))+fix(tn(25)))/sum(fix(tn(:)))*100);
DTI.Cell(6,4).Range.Text =num2str(100.00);
DTI.Cell(7,4).Range.Text = '-';
DTI.Cell(8,4).Range.Text = '-';
DTI.Cell(9,4).Range.Text = '-';
DTI.Cell(10,4).Range.Text = '-';
DTI.Cell(11,4).Range.Text = '-';


figure;
pie_table=zeros(9,1);
pie_table(1)=nnz(y==0);
pie_table(2)=nnz(y>0 & y<=10);
pie_table(3)=nnz(y>10 & y<=20);
pie_table(4)=nnz(y>20 & y<=30);
pie_table(5)=nnz(y>30 & y<=40);
pie_table(6)=nnz(y>40 & y<=50);
pie_table(7)=nnz(y>50 & y<=60);
pie_table(8)=nnz(y>60 & y<=70);
pie_table(9)=nnz(y>70 & y<=80);

explode=[0,0,0,0,0,0,0,0,0];
pie(pie_table,explode);
title('速度分段比例');
legend('y=0','0<y<=10','10<y<=20','20<y<=30','30<y<=40','40<y<=50','50<y<=60','60<y<=70','70<y<=80','Location','eastoutside');
print -dbitmap %% 复制曲线图

selection.Range.Paste;
end_of_doc = get(content,'end');
set(selection,'Start',end_of_doc);
selection.MoveDown;

%% 保存文档
Document.ActiveWindow.ActivePane.View.Type = 'wdPrintView';
document = invoke(document,'SaveAs',file_name); % 保存文档
Word.Quit; % 关闭文档
disp(strcat(imname,'文档处理完毕！请在当前文件夹中查看！'));%% 提示信息xxxx文档处理完毕
cd ..       %%退出output目录
end  %%function




