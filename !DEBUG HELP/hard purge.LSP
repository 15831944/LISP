;;;;  ACAD_DGNLINESTYLECOMP - типы линий и текстовые стили
;;;   словарь Bentley MicroSystems - содержит много ненужного овна
;;   AEC_*
;;   - external referrenes

(do #actdoc)

(do (vla-get-Linetypes #actdoc))


(do (vla-item (vla-get-Linetypes #actdoc) 112))


(VLA-DELETE (vla-item (vla-get-Linetypes #actdoc) 112))




(do (vla-get-Layers #actdoc))


(do (vla-item (vla-get-Layers #actdoc) 3))






(setq lst (ss->list* (ssget "_X"))) (princ)
(setq lst (ss->list* (ssget))) (princ)
(length lst)

(setq lst (vl-remove-if-not '(lambda (x) (assoc -3 (entget x '("*")))) lst))

(entget (car lst) '("*"))

(setq lst (vl-remove-if '(lambda (x) (= "ACAD" (car (cadr (assoc -3 (entget x '("*"))))))) lst))
(length lst)


(car (cadr (assoc -3 (entget (last lst) '("*")))))




(setq lst (ss->list* (ssget)))

(mapcar
  '(lambda (x)
     (if (assoc -3 (entget x '("*")))
       (setq ll (cons x ll))
       )
     )
  lst)

(length ll)

(assoc -3 (entget (nth 13 ll) '("*")))








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

;;;;;;;;             RegisteredApplications                   
(do #actdoc)
(setq regapps (vla-get-RegisteredApplications #actdoc))
;(cdo (vla-get-RegisteredApplications #actdoc))

(setq regapps (cont>list regapps))
(setq regappsToDel '())
(setq regappsUsed '())

(mapcar
  '(lambda (ra / name ss)	;(setq ra (nth 13 regapps))
     (setq name (vla-get-name ra))
     (if (null (setq ss (ssget "X" (list (list -3 (list name))))))
       (setq regappsToDel (cons ra regappsToDel))
       (setq regappsUsed (cons ra regappsUsed))
       )
     (princ)
     )
  regapps)

(length regappsToDel)
(length regappsUsed)



(mapcar '(lambda (x) (vla-get-name x)) regappsToDel)
(mapcar '(lambda (x) (vla-get-name x)) regappsUsed)

(mapcar '(lambda (x) (vla-delete x)) regappsToDel)





(setq lst (ss->list* (ssget "X" '((-3 ("GENIUS_GENOBJ-NBEHI-BHF_13"))))))
(sssetfirst nil (lst-to-ss lst))



(setq lst (ss->list* (ssget "X" '((-3 ("*"))))))
(length lst)
(car lst)

(setq lst (ss->list* (ssget)))
(setq lst (vl-remove-if-not '(lambda (x / xd)
			       (and
				 (setq xd (assoc -3 (entget x '("*"))))
				 (/= "ACAD" (car (cadr xd)))
				 )
			       
			       ) lst))
(length lst)

(ssget)

(mapcar
  '(lambda (x / xd)
     (setq xd (assoc -3 (entget x '("*"))))
     (car (cadr xd))
     )
  lst)


(assoc -3 (entget (nth 13 ll) '("*")))







(do (vla-item regapps "IdsDescr"))
(entget (vlax-vla-object->ename (vla-item regapps "IdsDescr")))

(do (vla-item regapps "N8SOL-TLINK"))
(entget (vlax-vla-object->ename (vla-item regapps "N8SOL-TLINK")))


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
(dumpdicts (vla-item (vla-get-dictionaries #actdoc) "AcDbVariableDictionary"))


(dumpdicts (vla-item (vla-get-dictionaries #actdoc) "ACAD_DATALINK"))



(setq dct (vla-item (vla-get-dictionaries #actdoc) "ACAD_DATALINK"))
(do dct)
(do (vla-item dct 0))
(vla-delete dct)





;	external references delete
(cdo (vla-get-dictionaries #actdoc))
(setq ACAD_IMAGE_DICT (vla-item (vla-get-dictionaries #actdoc) "ACAD_IMAGE_DICT"))
(do ACAD_IMAGE_DICT)
(cdo ACAD_IMAGE_DICT)
(vla-delete (vla-item VETCAD_DICT 0))
(vla-delete VETCAD_DICT)

(setq ACAD_IMAGE_DICT (vla-item (vla-get-dictionaries #actdoc) "ACAD_IMAGE_DICT"))
(cdo CONLABELDictionary)
(cdo ACAD_IMAGE_DICT)
(do (vla-item CONLABELDictionary 0))
(vla-delete (vla-item CONLABELDictionary 0))

(do (vla-item ASE_INDEX_DICTIONARY 0))


(vla-GetXRecordData (vla-item ASE_INDEX_DICTIONARY 0) 'a 'b)
(variantextraction a)
(length (variantextraction b))

(mapcar 'cons (variantextraction a) (variantextraction b))

(vla-delete ASE_INDEX_DICTIONARY)
(vlax-release-object ASE_INDEX_DICTIONARY)
(setq ASE_INDEX_DICTIONARY nil)






(setq ASEBlockHierarchyIndexRecord (vla-item ASE_INDEX_DICTIONARY "ASEBlockHierarchyIndexRecord"))
(do ASEBlockHierarchyIndexRecord)







;ACMESTATEMGR ((3 . "ACMESTATEMGR") (350 . <Entity name: 7c1e48c8>))
(nth (+ 6 (1+ (* 2 27))) (entget (namedobjdict)))
(nth (+ 7 (1+ (* 2 27))) (entget (namedobjdict)))
(dictremove (namedobjdict) "AMI_MASTER")

(do (vla-item dicts 27))
(vla-Delete (vla-item dicts 30))
(entget (vlax-vla-object->ename (vla-item dicts 27)))







(entget (cdr (cadr (member '(3 . "AcAmCatalogState") (entget (namedobjdict))))))


(setq adict (vla-item dicts "ACAD_DATALINK"))
(dictremove (namedobjdict) "ACAD_DGNLINESTYLECOMP")



(dictremove (namedobjdict) "AEC_DISPLAY_PROPS_DEFAULTS")
(dictremove (namedobjdict) "AEC_DISP_REPS")



(vlax-release-object adict)

(set 'gp 'vlax-get-property)


(gp adict "Item" 1)



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


(do (setq clay (vla-item layers "0_Осн")))
(do (setq clay (vla-item layers "1_Осн")))
(do (setq clay (vla-item layers "Phase_A")))
1_Осн
(vla-get-HasExtensionDictionary clay)


(vl-remove-if '(lambda (clay) (= :vlax-false (vla-get-HasExtensionDictionary clay))) (cont>list layers))



(setq exd (vla-GetExtensionDictionary clay))
(do exd )
(vla-GetXData exd "*" 'v1 'v2)
(do (vla-item exd 0))
(vla-GetXRecordData (vla-item exd 0) )




















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
     (setq ans (cons (list i (vla-get-objectname cres) cres) ans))
     )
    )
  (setq i (1- i))
  )
(length ans)

ans


(setq tmp (vl-remove-if-not '(lambda (x) (member (cadr x) '("AcDbZombieObject"))) ans))
(length tmp)










(setq hp:baseblocks
       '("AcDbAttribute" "AcDbBlockRepresentationData" "AcDbEvalGraph"
	 "AcDbBlockPointParameter" "AcDbBlockXYGrip" "AcDbBlockGripExpr"
	 "AcDbBlockStretchAction" "AcDbDynamicBlockPurgePreventer"
	 "AcDbSequenceEnd" "AcDbSortentsTable"
	 AcDbPoint
	)
)
(setq hp:basegraphical
       '("AcDbText" "AcDbMText"	"AcDbLine" "AcDbPolyline" "AcDbCircle"
	 "AcDbArc" "AcDbHatch" "AcDbSolid" "AcDbBlockReference"
	 "AcDbAttributeDefinition" "AcDbPoint"
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




(setq tmp (vl-remove-if '(lambda (x) (member (cadr x)
					     (append
					       hp:basegraphical
					       hp:baseblocks
					       hp:basenongraphical
					       )
					     )) ans))

(setq tmp (vl-remove-if '(lambda (x) (member (cadr x) '("none"))) tmp))
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








(defun dec>hex (int / power neg int result div remain posval)
  (setq
    power 1
    neg (minusp int)
    int (abs int)
    result ""
  )
  (while (> int 0)
    (setq
      div (expt 16 power)
      remain (rem int div)
      posval (/ remain (expt 16 (1- power))); POSition VALue
      int (- int remain)
      result
        (strcat
          (if (< posval 10)
            (itoa posval)
            (chr (+ 55 posval))
          )
          result
        )
      power (1+ power)
    )
  )
  (strcat
    (if neg "-" "")
    (if (= result "") "0" result)
  )
);defun



(defun hex>dec (hndl / result neg power tmp)
  (if (/= (type hndl) 'STR)
    (progn
      (alert "Requires string argument.")
      (quit)
    ); end progn
  ); end if
  (setq
    hndl (strcase hndl)
    result 0
  ); end setq
  (if (= (substr hndl 1 1) "-")
    (setq neg T hndl (substr hndl 2))
  ); end if
  (if (/= (vl-string-trim "0123456789ABCDEF" hndl) "")
    (progn
      (alert "Invalid hexadecimal string.")
      (quit)
    ); end progn
  ); end if
  (repeat (setq power (strlen hndl))
    (setq result
      (+
        result
        (*
          (-
            (setq tmp (ascii (substr hndl 1 1)))
            (if (> tmp 64) 55 48)
          ); end -
          (expt 16 (setq power (1- power)))
        ); end *
      ); end +
      hndl (substr hndl 2)
    ); end setq
  ); end while
  (if neg (- result) result)
); end defun - hex2int
