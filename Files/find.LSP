(setq fldr (kd:getfolderdlg  "" ""))

(VL-DIRECTORY-FILES fldr 0)

(setq exclist (list
		"." ".."		
		"! Нормоконтроль замечания"
		"!!!! - ACAD system - !!!!"
		"!!!!! catalogs & documentations"
		"!!Чертежи других организаций"
		"ACAD electrical" "AutomatiCS ADT" "SchematiCS"
		"KKS" "tmp" "out.txt"
		"_English" "_проекты домов"
		"Задания" "Заявления" "к 410"
		"ОТ Аллы" "письма" "ПУЭ.pdf"
		"Расшифровка.jpg"	      "Рисунок2.dwg"
		"СО 34.35.101-2003.doc"  "ящег для мусора"
		))




(vl-remove-if '(lambda (x) (member x exclist)) (VL-DIRECTORY-FILES fldr "*.*" 0))