// ����� 03\Book01\d_tpos.dcl
// � �����: �.�.�������, �.�.��������
//"AutoLISP � Visual LISP � ����� AutoCAD"
// (������������ "���-���������", 2006)
//
// ������� 3.1. ���� d_tpos.dcl
//

np_tpos: dialog
{label="���������";
  :edit_box{label="������ �������";key="kShir";value="750";edit_width=6;}
  :edit_box{label="������ �������";key="kVys";value="300";edit_width=6;}
  :edit_box{label="������ ����";key="kHbuk";value="180";edit_width=6;}
  :spacer{height=1;}
  :edit_box{label="���������� �����";key="kNumbalk";
            value="8";edit_width=6;}
  :edit_box{label="���������� ������ � ������";key="kNumkoks";
            value="17";edit_width=6;}
  :spacer{height=1;}
  :radio_row	{label="����� ������������� � �������";
    		:radio_button{label="�� ��������";key="kPoStolb";value="1";}
    		:radio_button{label="�� �������";key="kPoStrok";value="0";}
    		:radio_button{label="��� ��� ���?";key="hz";value="0";}
  		}
  :spacer{height=1;}
  ok_cancel;
}// ����� np_tpos
