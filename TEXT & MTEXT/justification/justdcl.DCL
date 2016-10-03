txtjust : dialog {label="txtjust";
	: row {
		: button {label="Влево";key="kleft";}
		: button {label="Центр";key="kcent";}
		: button {label="Вправо";key="kright";}
	}
	: button {label="Выровненный";key="kstrait";}
	: button {label="Середина";key="kmid";}
	: button {label="По ширине";key="kwidth";}
    spacer_1;	
	: row {
		: button {label="Вверх Влево";key="tl";}
		: button {label="Вверх Центр";key="tc";}
		: button {label="Вверх Вправо";key="tr";}
	}
	: row {
		: button {label="Середина Влево";key="cl";}
		: button {label="Середина Центр";key="cc";}
		: button {label="Середина Вправо";key="cr";}
	}
	: row {
		: button {label="Вниз Влево";key="bl";}
		: button {label="Вниз Центр";key="bc";}
		: button {label="Вниз Вправо";key="br";}
	}
    spacer_1;
    ok_cancel;
}
