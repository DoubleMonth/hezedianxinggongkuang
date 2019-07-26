%% 生成WORD报告

string = strcat('测试','市区循环工况报告'); %%组成带excle文件名的市区循环工况报告
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
row = 8;%%行数
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
column_width=[80.575,70.7736,80.575,70.7736,80.575,70.7736,80.575,70.7736];
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

DTI.Cell(2, 1).Merge(DTI.Cell(4, 1));
DTI.Cell(5, 1).Merge(DTI.Cell(6, 1));

DTI.Cell(2,1).Range.Text = '合并2-4';
DTI.Cell(3,1).Range.Text = '33';
DTI.Cell(5,1).Range.Text = '合并6-1';
DTI.Cell(6,1).Range.Text = '66';
% %% 保存文档
% Document.ActiveWindow.ActivePane.View.Type = 'wdPrintView';
% document = invoke(document,'SaveAs',file_name); % 保存文档
% Word.Quit; % 关闭文档
% disp(strcat(file_name,'文档处理完毕！请在当前文件夹中查看！'));%% 提示信息xxxx文档处理完毕
% cd ..       %%退出output目录




