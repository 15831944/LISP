// Глава 03\Book01\d_tpos.dcl
// В книге: Н.Н.Полещук, П.В.Лоскутов
//"AutoLISP и Visual LISP в среде AutoCAD"
// (издательство "БХВ-Петербург", 2006)
//
// Листинг 3.1. Файл d_tpos.dcl
//

np_tpos: dialog
{label="Настройка";
  :edit_box{label="Ширина таблицы";key="kShir";value="750";edit_width=6;}
  :edit_box{label="Высота таблицы";key="kVys";value="300";edit_width=6;}
  :edit_box{label="Высота букв";key="kHbuk";value="180";edit_width=6;}
  :spacer{height=1;}
  :edit_box{label="Количество балок";key="kNumbalk";
            value="8";edit_width=6;}
  :edit_box{label="Количество коксов в балках";key="kNumkoks";
            value="17";edit_width=6;}
  :spacer{height=1;}
  :radio_row	{label="Балки располагаются в таблице";
    		:radio_button{label="по столбцам";key="kPoStolb";value="1";}
    		:radio_button{label="по строкам";key="kPoStrok";value="0";}
    		:radio_button{label="как еще мот?";key="hz";value="0";}
  		}
  :spacer{height=1;}
  ok_cancel;
}// конец np_tpos
