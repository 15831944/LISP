;;;;  ACAD_DGNLINESTYLECOMP - типы линий и текстовые стили
;;;   словарь Bentley MicroSystems - содержит много ненужного овна
;;   AEC_*
;;   - external referrenes


(do #actdoc)


;;;;;;;;             RegisteredApplications                   
(setq regapps (vla-get-RegisteredApplications #actdoc))
(cdo (vla-get-RegisteredApplications #actdoc))

(do (vla-item regapps "PE_URL"))
(entget (vlax-vla-object->ename (vla-item regapps "CAD_PROFI")))

(do (vla-item regapps "N8SOL-TLINK"))
(entget (vlax-vla-object->ename (vla-item regapps "N8SOL-TLINK")))




;;;;;;;;             проход по расширенным данным                   
(setq lst (ss->list* (ssget "_X")))
(length lst)
(setq lst (vl-remove-if-not '(lambda (x) (assoc -3 (entget x '("*")))) lst))
;;  название расширенных данных
(setq res (mapcar '(lambda (x) (car (cadr (assoc -3 (entget x '("*"))))) ) lst))
(vl-remove-if '(lambda (x) (member x '("AcDbBlockRepETag" "AEC_XDATA_BOUND_SPACE" "ACAD"))) res)




















  (mapcar
    '(lambda (x)
       (if
	 (vlax-property-available-p x "name")
	 (princ (strcat "\n" (vla-get-name x)))
	 )
       )
    (kd-container->list (vla-get-dictionaries #actdoc))
    )










(setq dicts (vla-get-dictionaries #actdoc))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(setq dicts (vla-get-dictionaries #actdoc) i -1) (princ)

(defun dumpdicts (dicts / i)
  (setq i -1)
(mapcar
  '(lambda (x)
     (princ "\n")
     (princ (strcat (itoa (setq i (1+ i))) "\t"))
     (if (vlax-property-available-p x "name")
       (princ (vla-get-name x))
       (princ (strcat (vla-get-ObjectName x) " = "   (cdr (nth (+ 6 (1+ (* 2 i))) (entget (namedobjdict))))))
       )
     (princ "\t")	
     (if (vlax-property-available-p x "Count")
       (princ (vla-get-Count x))
       (princ "nil"))
     )
  (kd-container->list dicts)
  )
  )
(dumpdicts (vla-get-dictionaries #actdoc))

(dumpdicts (vla-item (vla-get-dictionaries #actdoc) "MCS_STREAM_DICT"))



(setq dct (vla-item (vla-get-dictionaries #actdoc) "ASE_INDEX_DICTIONARY"))
(do dct)
(do (vla-item dct 0))

(vla-GetXRecordData (vla-item dct 0) 'a 'b)
(vlax-safearray->list a)
(mapcar
  '(lambda (x)
     (vlax-safearray->list (vlax-variant-value x))
     )
  (vlax-safearray->list b)
  )

(vla-delete (vla-item dct 0))
(vla-delete dct)





;	external references delete
(setq ACAD_IMAGE_DICT (vla-item (vla-get-dictionaries #actdoc) "ACAD_IMAGE_DICT"))
(do (vla-item ACAD_IMAGE_DICT 0))
(vla-delete (vla-item ACAD_IMAGE_DICT 0))











(do (vla-get-Linetypes #actdoc))
(do (vla-item (vla-get-Linetypes #actdoc) 112))
(VLA-DELETE (vla-item (vla-get-Linetypes #actdoc) 112))
(do (vla-get-Layers #actdoc))
(do (vla-item (vla-get-Layers #actdoc) 3))





;ACMESTATEMGR ((3 . "ACMESTATEMGR") (350 . <Entity name: 7c1e48c8>))
(nth (+ 6 (1+ (* 2 27))) (entget (namedobjdict)))
(nth (+ 7 (1+ (* 2 27))) (entget (namedobjdict)))
(dictremove (namedobjdict) "AMI_MASTER")

(do (vla-item dicts 27))
(vla-Delete (vla-item dicts 30))
(entget (vlax-vla-object->ename (vla-item dicts 27)))







(entget (cdr (cadr (member '(3 . "AcAmCatalogState") (entget (namedobjdict))))))


(setq adict (vla-item dicts "ACAD_DGNLINESTYLECOMP"))
(dictremove (namedobjdict) "ACAD_DGNLINESTYLECOMP")



(dictremove (namedobjdict) "AEC_DISPLAY_PROPS_DEFAULTS")
(dictremove (namedobjdict) "AEC_DISP_REPS")



(vlax-release-object adict)

(do adict)
(do (vla-item adict 1))

(vlax-for obj adict
  (vla-Delete obj)
  )



(entget (vlax-vla-object->ename (vla-item adict 1)))






(do (vla-item dicts "MCS_STREAM_DICT"))

(entget (vlax-vla-object->ename dicts) '("*"))

(entget (vlax-vla-object->ename (vla-item dicts "MCS_STREAM_DICT")) '("*"))

(vla-GetXRecordData (vla-item (vla-item dicts "MCS_STREAM_DICT") "MCS_PARAMS_HIDDEN_DATA") 'a 'b)



(variantextraction b)










(do (vla-item mcs 0))

(entget (vlax-vla-object->ename (vla-item mcs 1)))

(vla-Delete (vla-item mcs 0))

(vla-Delete mcs)



(mapcar
  '(lambda (d)
     (if
       (and
	 (vlax-property-available-p d "name")
	 (null (wcmatch (vla-get-name d) "ACAD*"))
	 )
       (vla-delete d)
	 
       )
     
     )
  (kd-container->list dicts)
  )




  (do (vla-item mcs 0))

  (setq xr (vla-item mcs 0))

  (defun kd:getxrecdata (xrec / sa1 sa2)
  (vla-getXrecordData xrec 'sa1 'sa2)
  (mapcar 'vlax-variant-value (vlax-safearray->list sa2))
  );defun

  (vlax-safearray->list (last (kd:getxrecdata xr)))

  (vla-delete (vla-item mcs 0))
  (vla-delete (vla-item mcs 1))
  (vla-delete (vla-item mcs 2))








;;;;;;;;             Layers                                   


(setq layers (vla-get-Layers #actdoc))
(entget (vlax-vla-object->ename layers) '("*"))
(cdo layers)


(do (setq clay (vla-item layers "NODES")))
(do (setq clay (vla-item layers "1_Осн")))
(do (setq clay (vla-item layers "невидимые_аттрибуты")))

(vla-get-HasExtensionDictionary clay)


(vl-remove-if '(lambda (clay) (= :vlax-false (vla-get-HasExtensionDictionary clay))) (cont>list layers))



(setq exd (vla-GetExtensionDictionary clay))
(do exd )
(vla-GetXData exd "*" 'v1 'v2)
(do (vla-item exd 0))
(vla-GetXRecordData (vla-item exd 0) )


(vla-delete exd)
(vlax-release-object exd)
(setq exd nil)



















  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








(setq e (entnext))
(while (setq e (entnext e))
  (setq eng (entget e '("*")))
  (setq a 
  (vl-remove-if
    '(lambda (x)
       (or
	 (member (car x) '(-1 1 0 11 13 14 15 16 281 146 292 282 141 142 63 421 17 38 39
			 170 61
			   48
			 72 73 6 7 51 110 111 112 79 410 348 340 12 74 68 91 90 68 69 330
			 360 102 370 5 100 67 8 62 2 10 40 41 42 43 50 70 71 44 45 210
			 1002 280 66
			 ))
	 ;(= ACET-TEXTMASK (car (cdr (assoc -3 x))))
	 
	 
	 )
       )
    eng
    )
	)
  (if a
    (progn
      (setq latseng a)
      (princ a)
      (princ "\n")
      )
    )
  )

  
(entget (setq e (entnext e)))


(do (setq obj (vla-HandleToObject #actdoc "C8514")))

(do (setq ownobj (vla-ObjectIDToObject #actdoc (vla-get-OwnerID obj))))

(do (vla-ObjectIDToObject #actdoc (vla-get-OwnerID ownobj)))





(entget (vlax-vla-object->ename ownobj) '("*"))



(setq o (nth 20 lst))
(setq exd (vla-getExtensionDictionary o))
(do (vla-item exd 0))



(while (setq e (entnext e))
  (setq eg (entget e '("*")))
  (if (setq a-3 (assoc -3 eg))
    (progn (princ "\n") (princ (assoc 0 eg)) (princ "\t") (princ a-3))
    )
  )




(setq lst (ss->lsto* (ssget "_I")))

(do (car lst))


(mapcar
  '(lambda (o / exd child)	;(setq o (nth 1 lst))
     (if (= :vlax-true (vla-get-HasExtensionDictionary o))
       (progn
	 (setq exd (vla-getExtensionDictionary o))
	 (if
	   (and
	     (> (vla-get-Count exd) 0)
	     (setq child (vla-item exd 0))
	     (= "AcDbZombieObject" (vla-get-ObjectName child))
	     )
	   (vla-delete child)
	   )
	 )
       )
     )
  lst
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;   VERY  HARD  PURGE    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(load (strcat #lisppath "MATH\\hex-dec.lsp"))


(setq lastobj (vla-addline #modspace (vlax-3d-point '(0 0 0)) (vlax-3d-point '(0 0 0))))
(setq i (hex>dec (vla-get-Handle lastobj)))
(vla-delete lastobj)
(setq ans nil)
(while (> i 0)
  (setq hand (dec>hex i))
  (setq cres (vl-catch-all-apply 'vla-HandleToObject (list #actdoc hand)))
  (cond
    ((= 'VL-CATCH-ALL-APPLY-ERROR (type cres)) (setq ans (cons (list i "none") ans)))
    ((= 'VLA-OBJECT  (type cres))
     ;(setq ans (cons (list i (vla-get-objectname cres) cres) ans))
     (setq ans (cons (list i (vla-get-objectname cres) cres (if (vlax-property-available-p cres 'Layer) (vla-get-layer cres) "" ))ans))
     )
    )
  (setq i (1- i))
  )
(length ans)

ans


(setq tmp ans) (princ)

(setq tmp (vl-remove-if '(lambda (x) (= "" (caddr x)) ) tmp))

(setq tmp (vl-remove-if-not '(lambda (x) (member (last x) targlay) ) tmp))
(setq tmp (vl-remove-if-not '(lambda (x) (member (last x) '("ТМ")) ) ans))



(do (caddr (car tmp)))


(do (vla-ObjectIDToObject #actdoc (vla-get-OwnerID (caddr (car tmp)))))


OwnerID


(setq tmp (vl-remove-if-not '(lambda (x) (member (cadr x) '("AcDbZombieObject"))) ans))
(length tmp)



(setq tmp (vl-remove-if '(lambda (x) (member (cadr x)
					     (append
					       hp:basegraphical
					       hp:baseblocks
					       hp:basenongraphical
					       )
					     )) ans))

(setq tmp (vl-remove-if '(lambda (x) (member (cadr x) '("none"))) tmp))
(setq tmp (vl-remove-if '(lambda (x) (member (cadr x) '("AcDbPoint"))) tmp))
(setq tmp (vl-remove-if '(lambda (x) (member (cadr x) '("AcDbSpline"))) tmp))
(setq tmp (vl-remove-if '(lambda (x) (member (cadr x) '("AcDbUCSTableRecord"))) tmp))
(setq tmp (vl-remove-if '(lambda (x) (member (cadr x) '("ExAcXREFPanelObject"))) tmp))


(do (last (assoc 116219 tmp)))

AcDbImpNonPersistentObjectsCollection
ExAcXREFPanelObject
AcDbCellStyleMap
AcDbUCSTableRecord
(length tmp)





(do (last (assoc 573 ans)))
(entget (vlax-vla-object->ename (last (assoc 33 ans))))

(do (setq ownobj (vla-ObjectIDToObject #actdoc (vla-get-OwnerID (last (assoc 583 ans))))))



;; owner of the owner of the zombie
;;;(mapcar
;;;  '(lambda (x)
;;;     (vla-ObjectIDToObject #actdoc (vla-get-OwnerID
;;;	(vla-ObjectIDToObject #actdoc (vla-get-OwnerID (last x)))
;;;	))
;;;     )
;;;  tmp
;;;  )


;;		ACTION
;(mapcar '(lambda (x) (vla-delete (last x)))tmp)


(setq hp:baseblocks
       '("AcDbAttribute" "AcDbBlockRepresentationData" "AcDbEvalGraph"
	 "AcDbBlockPointParameter" "AcDbBlockXYGrip" "AcDbBlockGripExpr"
	 "AcDbBlockStretchAction" "AcDbDynamicBlockPurgePreventer"
	 "AcDbSequenceEnd" "AcDbSortentsTable"
	)
)
(setq hp:basegraphical
       '("AcDbText" "AcDbMText"	"AcDbLine" "AcDbPolyline" "AcDbCircle"
	 "AcDbArc" "AcDbHatch" "AcDbSolid" "AcDbBlockReference"
	 "AcDbAttributeDefinition"
	)
)
(setq hp:basenongraphical
       '("AcDbPlaceHolder" "AcDbBlockTable" "AcDbBlockTableRecord"
	 "AcDbBlockBegin" "AcDbBlockEnd" "AcDbLayerTable"
	 "AcDbLayerTableRecord"	"AcDbTextStyleTable"
	 "AcDbTextStyleTableRecord" "AcDbLinetypeTable"
	 "AcDbLinetypeTableRecord" "AcDbViewTable" "AcDbViewport"
	 "AcDbViewportTable" "AcDbViewportTableRecord" "AcDbScale"
	 "AcDbUCSTable"	"AcDbMlineStyle" "AcDbMLeaderStyle"
	 "AcDbDimStyleTable" "AcDbDimStyleTableRecord" "AcDbTableStyle"
	 "AcDbFontTable" "AcDbFontTableRecord" "AcDbLayout"
	 "AcDbMaterial"	"AcDbVisualStyle" "AcDbSectionViewStyle"
	 "AcDbDetailViewStyle" "AcDbVXTable" "AcDbVXTableRecord"
	 "AcDbDictionaryWithDefault" "AcDbRegAppTable"
	 "AcDbRegAppTableRecord" "AcDbDictionary" "AcDbDictionaryVar"
	 "AcDbXrecord"
	)
)



