//   ��������

dcl_ktz_numerator: dialog

{label="ktz-numerator";
	:edit_box{label="���������� ����� ��������� �����"; key="pnatt"; edit_width=6; value=1; children_alignment=centered; children_fixed_width=true;}
	:edit_box{label="������ ����� ��������� (001)"; key="z"; edit_width=6; value=1;}
	:edit_box{label="����������"; key="dz"; edit_width=6; value=1;}
	:edit_box{label="�������"; key="lit"; edit_width=6;}
	:edit_box{label="�������"; key="suf"; edit_width=6;}
	:spacer{height=1;}
	:row {
	      :radio_column{label="����������"; key="a"; children_alignment=centered; children_fixed_width=true;
	      	:radio_button{label="XY"; key="a1"; value="1";}
	      	:radio_button{label="YX"; key="a2"; value="0";}
	      	}
	      :spacer{width=1;}	 
	      :radio_column{label="1-�� ��������"; key="b";
	         :radio_button{label="�� �����������"; key="b1"; value="1";}
	         :radio_button{label="�� ��������"; key="b2"; value="0";}
	      	 }
	      :spacer{width=1;}   
	      :radio_column{label="2-�� ��������"; key="c";
	         :radio_button{label="�� �����������"; key="c1"; value="0";}
	         :radio_button{label="�� ��������"; key="c2"; value="1";}
	         }
	      }
	      :paragraph{
	      	:text_part{label="��� ��������� �� ���� �����������, ���� �";}
	      	:text_part{label="������� ��������� ������ ���� ������ �������";}
	      	}
ok_cancel;
}//dialog