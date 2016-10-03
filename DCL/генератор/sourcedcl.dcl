X_contact_dia : dialog {width=100;
    : row {
    	: text {value="none"; key="block-effective-name";}
    	: button {label="выбрать"; key="kgetent";}//width=10;fixed_width=true;}
        : edit_box {label="имя словаря"; key="cont_dict_name"; value="contacts";}
        : button {label="show";width=10; fixed_width=true;}
    }
    : boxed_row {label="Dictionary";
    	: list_box {key="lstbox";}
        : button {label="delete"; fixed_width=true;width=10;}
    }
    : row {
    	:column {
    		: text {value="Name";}
    		: edit_box {key="cname";}
        	}
        :column {
        	: text {value="point";}
        	: edit_box {key="cpoint";}
        	}
        :column {
        	: text {value="type";}
        	: edit_box {key="ctype";}
        	}
        :column {
        	: text {value="polar";}
        	: edit_box {key="cpolar";}
        	}
        : button {label="Add";width=10;fixed_width=true;fixed_height=false; height=3;}
        }
    spacer_1;
    ok_cancel;
}
