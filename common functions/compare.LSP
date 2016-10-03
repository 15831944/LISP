
(setq dwgdata (mapcar 'car (cdr tbl)))


(setq osodata (mapcar 'car (excel>lst)))
(deoriglist osodata)

(setq kipdata (mapcar 'car (excel>lst)))
(deoriglist kipdata)

(length osodata)
(length kipdata)

(db|diff kipdata osodata)