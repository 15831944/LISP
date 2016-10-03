
: edit_box
	{
	label="";
	value="";
	key="";
	width=00;
	height=00;
	initial_focus="";
	children_alignment=left,right,centered,top,bottom;
	children_fixed_width=true,false;
	children_fixed_width=height,false;
	action=""; /// текст лисп-строки
	alignment=left,centered;
	allow_accept=false,true;
	aspect_ratio=00; // = width/height
	big_increment=00;//slider
	small_increment=00;//slider
	color=0...255, dialog_line, dialog_foreground, dialog_background, graphics_background, black, red, yellow, green, cyan, blue, magenta, whitegraphics_foreground; // for image
	edit_limit=00;
	edit_width=00;
	fixed_height=true;
	fixed_width=true;
	fixed_width_font=true;
	is_cancel=true; //button - только одна кнопка в диалоге может быть is_cancel=true; for ESC-press
	is_default=true // for Enter-press
	is_enabled
	is_tab_stop
	layout= horisontal, vertical; //slider
	max_value=00; //slider
	min_value=00; //slider
	mnemonic=;
	multiple_select
	password_char
	tabs="2 5 1 8 4" // порядок табуляции for listbox, popuplist
	tab_truncate=true // обрезка длинных значений при переходе за табуляцию
	

	}