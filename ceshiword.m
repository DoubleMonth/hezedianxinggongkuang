%% ����WORD����

string = strcat('����','����ѭ����������'); %%��ɴ�excle�ļ���������ѭ����������
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
    document = invoke(documents,'Open',file_name);% ����Ӧ�ļ�������������档
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
row = 8;%%����
column = 8; %%����
selection.MoveDown;
set(paragraphformat, 'Alignment','wdAlignParagraphCenter');
set(selection, 'Text','��1�� ��������ѭ��');
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
row_height =zeros(row,1);  %% �и�
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
DTI.Cell(1,1).Range.Text = '��ת����';%����Ҫ����
DTI.Cell(1,2).Range.Text = '����״̬';
DTI.Cell(1,3).Range.Text = '�������';%����Ҫ����
DTI.Cell(1,4).Range.Text = '���ٶ� m/s^2';
DTI.Cell(1,5).Range.Text = '�ٶ� km/h';%����Ҫ����
DTI.Cell(1,6).Range.Text = '����ʱ�� s';
DTI.Cell(1,7).Range.Text = '����ʱ��';%����Ҫ����
DTI.Cell(1,8).Range.Text = '�ۼ�ʱ��';

DTI.Cell(2, 1).Merge(DTI.Cell(4, 1));
DTI.Cell(5, 1).Merge(DTI.Cell(6, 1));

DTI.Cell(2,1).Range.Text = '�ϲ�2-4';
DTI.Cell(3,1).Range.Text = '33';
DTI.Cell(5,1).Range.Text = '�ϲ�6-1';
DTI.Cell(6,1).Range.Text = '66';
% %% �����ĵ�
% Document.ActiveWindow.ActivePane.View.Type = 'wdPrintView';
% document = invoke(document,'SaveAs',file_name); % �����ĵ�
% Word.Quit; % �ر��ĵ�
% disp(strcat(file_name,'�ĵ�������ϣ����ڵ�ǰ�ļ����в鿴��'));%% ��ʾ��Ϣxxxx�ĵ��������
% cd ..       %%�˳�outputĿ¼




