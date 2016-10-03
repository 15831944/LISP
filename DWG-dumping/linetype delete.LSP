(vl-load-com)

(setq cad (vlax-get-acad-object))
(do cad)

(setq adoc (vla-get-ActiveDocument cad))
(do adoc)

(setq ls (vla-get-Linetypes adoc))

(do ls)

(vlax-map-Collection ls 'do)

(setq qwe (vla-item ls "BNP-Ã¿—ÀﬂÕ€≈-—“Œ »"))

(do qwe)

(vla-Delete qwe)


(setq ms (vla-get-ModelSpace adoc))
(setq dict (vla-get-Dictionaries adoc))

(setq dbs (vla-get-Database adoc))
(vlax-map-Collection dict 'do)

(setq lsret (vla-item dict "ACAD_MLINESTYLE"))
(vla-delete lsret)
(do lsret)
(vla-delete (vla-item lsret 0))
