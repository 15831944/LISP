;; 14_07_14
(vl-load-com)
(setq #cad (vlax-get-acad-object)
      #actdoc (vla-get-activedocument #cad)
      #modspace (vla-get-modelspace #actdoc))

;(setq #BNP:BLOCKSPATH "\\\\srv-energo\\acad\\!_Стандарт\\Blocks\\")
(setq #BNP:BLOCKSPATH (strcat #lisppath "!blocking\\"))
(setq #BNP:TEXTSTYLENAME "GOST 2.304")
(setq #BNP:MLEADERSTYLENAME "bnp-mleaderstyle")
(setq #BNP:MLEADERSLAYERNAME "com_text")
(setq arrowblockname "joint")





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun BNPST|mleaderstyleinit ( / dictmlstyles )
  (setq dictmlstyles (vla-item (vla-get-dictionaries #actdoc) "ACAD_MLEADERSTYLE"))
  (if (null (member #BNP:MLEADERSTYLENAME (mapcar 'vla-get-name (cont>list dictmlstyles))))
    (BNPST|addmleaderstyle #BNP:MLEADERSTYLENAME)
    )
  (setvar "CMLEADERSTYLE" #BNP:MLEADERSTYLENAME)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun BNPST|addmleaderstyle (mleaderstylename / mlstyleproperties arrowblock #BNP:MLEADERSTYLE)
  (setq #BNP:MLEADERSTYLE (vla-addobject (vla-item (vla-get-dictionaries #actdoc) "ACAD_MLEADERSTYLE") mleaderstylename "AcDbMLeaderStyle"))
  (if (null (member arrowblockname (mapcar 'vla-get-name (cont>list (vla-get-blocks #actdoc)))))
    (progn
      (vl-cmdf "_.INSERT" (strcat #BNP:BLOCKSPATH arrowblockname ".dwg"))
      (vl-cmdf)
      )
    )
  
  
  (setq mlstyleproperties
       (list
	 '("AlignSpace" 4.0)
	 '("Annotative" 0)
	 ;'("ArrowSize" 1.0)
	 '("ArrowSize" 0.5)
	 (list "ArrowSymbol" arrowblockname)
	 '("BitFlags" 7274610)
	 '("BlockConnectionType" 0)
	 '("BlockRotation" 0.0)
	 '("BlockScale" 1)
	 '("BreakSize" 0.0)
	 '("ContentType" 2)
	 '("Description" "")
	 '("DoglegLength" 1.0)
	 '("DrawLeaderOrderType" 0)
	 '("DrawMLeaderOrderType" 1)
	 '("EnableBlockRotation" -1)
	 '("EnableBlockScale" -1)
	 '("EnableDogleg" -1)
	 '("EnableFrameText" 0)
	 '("EnableLanding" -1)
	 '("FirstSegmentAngleConstraint" 0)
	 '("LandingGap" 1.0)
	 '("LeaderLinetype" 1)
	 '("LeaderLineTypeId" "ByBlock")
	 '("LeaderLineWeight" -2)
	 '("MaxLeaderSegmentsPoints" 2)
	 '("ScaleFactor" 1.0)
	 '("SecondSegmentAngleConstraint" 0)
	 '("TextAlignmentType" 1)
	 '("TextAngleType" 1)
	 '("TextAttachmentDirection" 0)
	 '("TextBottomAttachmentType" 0)
	 '("TextHeight" 2.5)
	 '("TextLeftAttachmentType" 3)
	 '("TextRightAttachmentType" 3)
	 '("TextString" "")
	 (list "TextStyle" #BNP:TEXTSTYLENAME)
	 '("TextTopAttachmentType" 0)
	 )
	)
  (mapcar
    '(lambda (pair)
       (vlax-put-property #BNP:MLEADERSTYLE (car pair) (cadr pair))
       )
    mlstyleproperties)
  (princ)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(BNPST|mleaderstyleinit)























(defun c:aml () (BNP|addmleader))

(defun BNP|addmleader ( / obj pt ptt ptvar mlparams ml:scale)
  (BNPST|mleaderstyleinit)
  (if
    (and
      (setq pt (vl-catch-all-apply 'getpoint (list "\nSpecify leader arrowhead location ")))
      (= 'LIST (type pt))
      (setq ptt (vl-catch-all-apply 'getpoint (list pt "\nSpecify leader landing location: ")))
      (= 'LIST (type ptt))
      (setq ptvar (vlax-make-variant (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 5)) (append pt ptt))))
      (setq obj (vla-AddMLeader #modspace ptvar 3))
      )
    (progn
      ;(if (null (setq mlparams (BNP|addmleader-dcl|getparams)))
	(setq mlparams '(("firstline" "Первая строка") ("secondline" "Вторая строка") ("enablejoint" "1")))
	;)
      ;(setq ml:scale (getvar "DIMSCALE"))
      ;(setq ml:scale 100)
      (setq ml:scale 1)
      (vla-put-TextString obj (strcat (cadr (assoc "firstline" mlparams)) "\n" (cadr (assoc "secondline" mlparams))))
      (cond
	((= "0" (cadr (assoc "enablejoint" mlparams))) (vla-put-ArrowheadType obj 19))
	;((= "1" (cadr (assoc "enablejoint" mlparams))) (vla-put-ArrowheadType obj 20))
	(T (princ))
	)
      (vla-put-TextLineSpacingStyle obj acLineSpacingStyleExactly)
      (vla-put-TextLineSpacingFactor obj 0.84)
      (if (not (tblobjname "layer" #BNP:MLEADERSLAYERNAME))
	(progn
	  (command "_.-layer" "_new" #BNP:MLEADERSLAYERNAME "_color" "161" "numeric" "")
	  (setq lays (vla-get-Layers #actdoc))
	  (setq lcol (vla-GetInterfaceObject #cad (strcat "AutoCAD.AcCmColor." (strcut (vla-get-Version #cad) 0 2))))
	  (vla-SetRGB lcol 201 201 201)
	  (vla-put-TrueColor (vla-item lays #BNP:MLEADERSLAYERNAME) lcol)
	  )
	)
      (vla-put-Layer obj #BNP:MLEADERSLAYERNAME)
      (vla-put-ScaleFactor obj ml:scale)
      )
    )
  );defun




;(BNP|addmleader-dcl|getparams)
(defun BNP|addmleader-dcl|getparams ( / keys dlgname lastInputFileName lastparams dclfilepath dlgfhand dclID result)
  (defun dcl:fsforfilename (str) (if (vl-string-search "\"" str) (apply 'strcat (sepstr str "\"")) str))
  (defun dcl:fsfordclvaluestring (str) (if (vl-string-search "\"" str) (antisep (sepstr str "\"") "\\\"") str))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (setq keys '("firstline" "secondline" "enablejoint"))
  (setq dlgname "BNP_MultiLeader_options")
  (setq dclfilepath (strcat (getenv "temp") "\\" dlgname ".dcl"))
  (setq lastInputFileName (strcat "\\dclget-lif-" dlgname ".tmp"))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun dlg|saveparams ( / fh res)	; keys lastInputFileName
    (mapcar '(lambda (key) (setq res (append res (list (list key (get_tile (strcat "key" key))))))) keys)
    (setq fh (open (strcat (getenv "temp") lastInputFileName) "w"))
    (mapcar '(lambda (par) (write-line (strcat (car par) "\t" (cadr par)) fh)) res)
    (close fh)
    res
    );defun
  (defun dlg|readparams ( / fh rl res)	; keys lastInputFileName
    (if (setq fh (open (strcat (getenv "temp") lastInputFileName) "r"))
      (progn (while (setq rl (read-line fh)) (setq res (append res (list (sepstr rl "\t"))))) (close fh))
      )
    res
    );defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun kd:dclget_done ( / lst)
    (setq lst (dlg|saveparams))
    (done_dialog)
    lst
    );defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  (setq lastparams (dlg|readparams))
  (setq dlgfhand (open dclfilepath "w"))
  (write-line (strcat dlgname ": dialog" "{label=\"" dlgname "\";") dlgfhand)
  
  (setq i 0)
  (write-line (strcat ":edit_box" "{" "label=\"\";"
      "key=\"" "key" (nth i keys) "\";"
      "edit_width=50;"
      "value=\"" (if lastparams (dcl:fsfordclvaluestring (cadr (assoc (nth i keys) lastparams))) "") "\";"
      "allow_accept=true;" "}")
    dlgfhand)
  
  (setq i 1)
  (write-line (strcat ":edit_box" "{" "label=\"\";"
      "key=\"" "key" (nth i keys) "\";"
      "edit_width=50;"
      "value=\"" (if lastparams (dcl:fsfordclvaluestring (cadr (assoc (nth i keys) lastparams))) "") "\";"
      "allow_accept=true;" "}")
    dlgfhand)

  (write-line ":row{" dlgfhand)
  (setq i 2)
  (write-line (strcat ":toggle" "{" "label=\"Включить точку\";"
      "key=\"" "key" (nth i keys) "\";"
      "value=" (if lastparams (cadr (assoc (nth i keys) lastparams)) "")";"
      "}")
    dlgfhand)
  (write-line (strcat ":image{key=\"ktz\"; alignment=centered; width=6;fixed_width=true;height=2;fixed_height=true;color=7;}") dlgfhand)
  (write-line "}" dlgfhand)
  
  (mapcar '(lambda (x) (write-line x dlgfhand)) '(":spacer{width=1;}" "ok_cancel;" "}"))
  (close dlgfhand)
  
  (if (or (< (setq dclID (load_dialog dclfilepath))0) (not (new_dialog dlgname dclID))) (exit))
  (start_image "ktz") (mapcar (function (lambda (x) (apply 'vector_image x))) '((3 6 3 22 73) (3 16 12 11 73) (3 16 11 22 73) (3 3 32 3 73) (17 3 17 22 73) (21 11 32 11 73) (32 11 21 22 73) (21 22 32 22 73) (24 15 28 19 73))) (end_image)
  (action_tile "accept"		"(setq result (kd:dclget_done))")
  (action_tile "is_default"	"(setq result (kd:dclget_done))")
  (action_tile "cancel" 	"(done_dialog 0)")
  (start_dialog)
  (unload_dialog dclID)
  result
  );defun


(princ
  (strcat "\n"
    "###################################################################################" "\n"
    "####################    блок настроек мультивынски загружен #######################" "\n"
    "#################### наберите AML  для добавления мультивыноски ###################" "\n"
    "###################################################################################" "\n"
    ))
