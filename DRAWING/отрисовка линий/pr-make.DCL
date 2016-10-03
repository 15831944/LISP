 
// **************************************************************
// *          Окно выбора типа проводника (начало)              *
// **************************************************************
provod1:dialog {label="Рисование прводника";
:spacer{width=0;height=1;}
:text{label="Выберите тип проводника";alignment=centered;}
:spacer{width=0;height=1;}
:row{
:column{label="Переменный ток";
:button{label="  220 Фаза  ";key="b11";width=12;}
:button{label="220 Нейтраль";key="b12";width=12;}
:spacer{width=0;height=2;}
}// конец COLUMN
:spacer{width=1;height=0;}
:column{label="Постоянный ток";
:button{label="    + 24    ";key="b21";width=16;}
:button{label="    - 24    ";key="b22";width=12;}
:spacer{width=0;height=2;}
}// конец COLUMN
:spacer{width=1;height=0;}
:column{label="Другое";
:button{label="Неопределено";key="b31";width=12;}
:button{label="   Земля    ";key="b32";width=12;}
:button{label="   Кабель   ";key="b33";width=12;}


}// конец COLUMN
}// конец ROW
:spacer{width=0;height=1;}
cancel_button;
}
// **************************************************************
// *          Окно выбора типа проводника (конец)               *
// **************************************************************


