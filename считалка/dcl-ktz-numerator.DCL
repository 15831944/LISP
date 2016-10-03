//   считалка

dcl_ktz_numerator: dialog

{label="ktz-numerator";
	:edit_box{label="Порядковый номер аттрибута блока"; key="pnatt"; edit_width=6; value=1; children_alignment=centered; children_fixed_width=true;}
	:edit_box{label="Первая цифра нумерации (001)"; key="z"; edit_width=6; value=1;}
	:edit_box{label="Приращение"; key="dz"; edit_width=6; value=1;}
	:edit_box{label="Префикс"; key="lit"; edit_width=6;}
	:edit_box{label="Суффикс"; key="suf"; edit_width=6;}
	:spacer{height=1;}
	:row {
	      :radio_column{label="Сортировка"; key="a"; children_alignment=centered; children_fixed_width=true;
	      	:radio_button{label="XY"; key="a1"; value="1";}
	      	:radio_button{label="YX"; key="a2"; value="0";}
	      	}
	      :spacer{width=1;}	 
	      :radio_column{label="1-ый параметр"; key="b";
	         :radio_button{label="По возрастанию"; key="b1"; value="1";}
	         :radio_button{label="По убыванию"; key="b2"; value="0";}
	      	 }
	      :spacer{width=1;}   
	      :radio_column{label="2-ой параметр"; key="c";
	         :radio_button{label="По возрастанию"; key="c1"; value="0";}
	         :radio_button{label="По убыванию"; key="c2"; value="1";}
	         }
	      }
	      :paragraph{
	      	:text_part{label="При нумерации по двум координатам, ряды и";}
	      	:text_part{label="колонны элементов должны быть строго ровными";}
	      	}
ok_cancel;
}//dialog