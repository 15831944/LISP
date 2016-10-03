(load (strcat #lisppath "common functions\\kd-container-list.LSP"))
(setq lts (vla-get-LineTypes #actdoc))

(mapcar 'vla-get-name (kd-container->list lts))


(vla-load lts "R-drain" "d:/!! ACAD work folder/!!!!! заготовки и настройки ACAD&SPDS/типы линий/РОССИЯ.lin")