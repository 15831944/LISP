;; 14_04_15.3
;; 14_06_03 изменил (унифицировал) названия полей
(vl-load-com)
(setq #cad (vlax-get-acad-object)
      #actdoc (vla-get-activedocument #cad)
      #modspace (vla-get-modelspace #actdoc))

;(setq #blockformatpath "\\\\srv-energo\\acad\\\\!_Стандарт\\Blocks\\format.dwg")
;(setq #blockformatpath "\\\\srv-energo\\acad\\\\!_Стандарт\\Blocks\\formatJaroslavl.dwg")
(setq #blockformatpath (strcat #lisppath "!blocking\\formatJaroslavl.dwg"))
(setq frmt|blockmain "formatJaroslavl")
(setq frmt|blockspec "format-spec")
(setq #frmt:allowedblocknames (list frmt|blockmain frmt|blockspec))



(defun c:addformat ()
  (vla-startundomark #actdoc)
  (acet-error-init (list (list "cmdecho" 0 "highlight" (getvar "highlight") "limcheck" 0 "osmode" 0) T));acet-error-init
  (addformat)
  (acet-error-restore)
  (vla-endundomark #actdoc)
  );defun


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun addformat ( / blk pt attfn)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun frmt|updateformatname (blk / attfn)
    (setq attfn (getbatt blk "FORMATNAME"))
    (vla-put-Textstring attfn (strcat "%<\\AcObjProp Object(%<\\_ObjId " (itoa (vla-get-ObjectID blk)) ">%).Parameter(31).lookupString>%"))
    )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun frmt|updatedate (blk / atts)
    (setq atts (getbattswcmatch blk "ДАТА*"))
    (mapcar '(lambda (att) (vla-put-Textstring att "%<\\AcVar Date \\f \"MM.yy\">%"))atts)
    )
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (if (and
	(setq pt (getpoint))
	(if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list (vla-get-Blocks #actdoc) frmt|blockmain)))
	  (setq blk (vla-InsertBlock #modspace (vlax-3d-point pt) #blockformatpath 1 1 1 0))
	  (setq blk (vla-InsertBlock #modspace (vlax-3d-point pt) frmt|blockmain 1 1 1 0))
	  )
	)
    (progn
      (if (not (tblobjname "layer" "com_formats")) (command "_.-layer" "_new" "com_formats" "_color" "250" "com_formats" ""))
      (vla-put-layer blk "com_formats")
      (frmt|updateformatname blk)
      (frmt|updatedate blk)
      (sui:init)
      (sui:formatlink blk)
      (vl-cmdf "_updatefield" (vlax-vla-object->ename blk) "")
      )
    )
  );defun



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun lst->ss (lst / ss)
  (setq ss (ssadd))
  (mapcar '(lambda (x) (ssadd (if (= 'VLA-OBJECT (type x)) (vlax-vla-object->ename x) x) ss))lst)
  ss
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ss->lsto* (ss / lsto)
  (setq lsto (reverse (ssnamex ss)))
  (while (listp (cadar lsto)) (setq lsto (cdr lsto)))
  (mapcar '(lambda (x) (vlax-ename->vla-object (cadr x))) lsto)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun getbatt (bobj tag / al)
  (if
    (and
      (vlax-method-applicable-p bobj "getattributes")
      (setq al (vlax-variant-value (vla-getattributes bobj)))
      (<= 0 (vlax-safearray-get-u-bound al 1))
      (setq al (vlax-safearray->list al))
      )
    (car (vl-remove-if-not '(lambda (x) (wcmatch (vla-get-tagstring x) (strcat tag "," (strcase tag))))al))
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun getbattswcmatch ( bobj str / al)
  (if (and
      (vlax-method-applicable-p bobj "getattributes")
      (setq al (vlax-variant-value (vla-getattributes bobj)))
      (<= 0 (vlax-safearray-get-u-bound al 1))
      (setq al (vlax-safearray->list al))
      )
    (vl-remove-if-not '(lambda (x) (wcmatch (vla-get-tagstring x) (strcat str "," (strcase str)))) al)
    )
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:sui:edit ( / ss props)
  (sui:init)
  (setq props (sui:getcustomprops))
  (setq props (kd:dcledittab props))
  (mapcar '(lambda (p) (sui:addcustomprop (car p) (cadr p))) props)
  (if (and (setq ss (ssget "_X" '((0 . "INSERT"))))
	   (setq ss (vl-remove-if-not '(lambda (x) (member (vla-get-EffectiveName x) #frmt:allowedblocknames)) (ss->lsto* ss))))
    (progn (mapcar 'sui:formatlink ss) (setq ss (lst->ss ss)) (vl-cmdf "_updatefield" ss ""))
    )
  );defun

(defun sui:init ( / baseprops props)
  (setq baseprops '(("project_number" "")("project_contractname1" "")("project_contractname2" "")("project_contractname3" "")("project_name1" "")("project_name2" "")("project_name3" "")))
  (setq props (sui:getcustomprops))
  (cond
    ((null props) (setq props (kd:dcledittab baseprops)) (mapcar '(lambda (p) (sui:addcustomprop (car p) (cadr p))) props))
    ((equal (mapcar 'car baseprops) (mapcar 'car props)) (princ))
    (T
     (sui:removethisprops (mapcar 'car baseprops))
     (mapcar
       '(lambda (p) (sui:addcustomprop (car p) (cadr p)))
       (mapcar '(lambda (pr / ass) (if (setq ass (assoc (car pr) props)) ass pr)) baseprops)
       )
     )
    )
  );defun
(defun sui:getcustomprops ( / sui quant lst paramname paramval)
  (setq sui (vla-get-SummaryInfo #actdoc))
  (setq quant (vla-NumCustomInfo sui))
  (while (>= (setq quant (1- quant)) 0)
    (vla-GetCustomByIndex sui quant 'paramname 'paramval)
    (setq lst (append lst (list (list paramname paramval))))
    )
  (reverse lst)
  );defun


(defun sui:removethisprops (lst / props sui quant)
  (setq sui (vla-get-SummaryInfo #actdoc))
  (setq quant (vla-NumCustomInfo sui))
  (setq props (mapcar 'car (sui:getcustomprops)))
  (mapcar '(lambda (pr) (if (member pr props) (vla-RemoveCustomByKey sui pr))) lst)
  );defun




(defun sui:addcustomprop (pn pv / sui quant lst n)
  (setq sui (vla-get-SummaryInfo #actdoc))
  (setq quant (vla-NumCustomInfo sui))
  (setq lst (sui:getcustomprops))
  (if (and lst (assoc pn lst))
    (progn (vla-SetCustomByKey sui pn pv) (princ (strcat "\nProperty { " pn " } has changed to " pv)))
    (progn (vla-AddCustomInfo sui pn pv) (princ (strcat "\nProperty { " pn " } has added as " pv)))
    )
  (princ)
  );defun

(defun sui:formatlink (blk / atts)
  (if (member (vla-get-EffectiveName blk) #frmt:allowedblocknames)
    (progn
      (setq atts (vlax-safearray->list (vlax-variant-value (vla-GetAttributes blk))))
      (mapcar
	'(lambda (att / ts as asc)
	   (setq ts (vla-get-TagString att))
	   (cond
	     ((= "PROJECT_NUMBER" ts) (setq as "project_number"))
	     ((= "PROJECT_CONTRACTNAME1" ts)	 (setq as "project_contractname1"))
	     ((= "PROJECT_CONTRACTNAME2" ts)	 (setq as "project_contractname2"))
	     ((= "PROJECT_CONTRACTNAME3" ts)	 (setq as "project_contractname3"))
	     ((= "PROJECT_NAME1" ts)	 (setq as "project_name1"))
	     ((= "PROJECT_NAME2" ts)	 (setq as "project_name2"))
	     ((= "PROJECT_NAME3" ts)	 (setq as "project_name3"))
	     (T (princ ));(strcat "\nАТТРИБУТ " ts " НЕ МОЖЕТ БЫТЬ ЗАЛИНКОВАН ")))
	     )
	   (if as (if (and (setq asc (assoc as (sui:getcustomprops))) (/= (cadr asc) ""))
		    (vla-put-TextString att (strcat "%<\\AcVar CustomDP." as ">%"))
		    (vla-put-TextString att "")))
	   )
	atts
	)
      )
    )
  );defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun kd:dcledittab (data / names props dlgname dclfilename
		      dcl-file-path hand dcl_id i lst kd:dcledittab_done)
  (setq names (mapcar 'car data)) (setq props (mapcar 'cadr data))
  (setq props
  (mapcar
    '(lambda (x / val tail)
       (if (vl-string-search "\"" x)
	 (progn
	   (setq val (reverse (sepstr x "\"")))
	   (setq tail (car val))
	   (setq val (mapcar '(lambda (s) (strcat s "\\\"")) (reverse (cdr val))))
	   (setq val (strcat (apply 'strcat val) tail))
	   ) x )) props))
  (setq dlgname "kd_dcledittab")
  (setq dclfilename (strcat "\\" dlgname ".dcl"))
  (defun kd:dcledittab_done ( / lst i)
    (setq lst '() i 0)
    (repeat (length props)
      (setq lst (append lst (list (get_tile (strcat "key" (itoa i))))))
      (setq i (1+ i))
      )
    (done_dialog)
    lst
    );defun
  (setq dcl-file-path (strcat (getenv "temp") dclfilename) hand (open dcl-file-path "w"))
  (mapcar '(lambda (x) (write-line x hand)) (list dlgname ": dialog" "{label=\"kakt00z dcltab edit window\";"))
  (setq i 0)
  (repeat (length props)
    (write-line (strcat
		  ":edit_box"
		  "{"
		  	"label=\"" (nth i names) "\";"
		  	"value=\"" (nth i props) "\";"
		  	"key=\"" (strcat "key" (itoa i)) "\";"
		  	"edit_width=40;"
		  	"allow_accept=true;"
		  	(if (= i 0) "active=true;" "")
		  "}")
      hand)
    (setq i (1+ i))
    );repeat
  (mapcar '(lambda (x) (write-line x hand)) '( ":spacer{width=1;}" "ok_cancel;" "}"))
  (close hand)
  (if (or (< (setq dcl_id (load_dialog (strcat (getenv "temp") dclfilename)))0) (not (new_dialog dlgname dcl_id))) (exit)) ;if
  (action_tile "accept"		"(setq lst (kd:dcledittab_done))")
  (start_dialog)
  (unload_dialog dcl_id)
  (mapcar 'list names lst)
  );defun
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;EOF