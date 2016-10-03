(vl-load-com)
;;; 14_01_14
;;; Программа для конвертации вставленных в чертеж описаний аттрибутов (AttDef) в тексты
;;; Запуск - из командной строки командой "a>t" [Enter] (без кавычек)


;;       ИНСТРУКЦИЯ ПО ИСПОЛЬЗОВАНИЮ LISP-файлов
;;
;; Если программа заархивирована, ее следует распаковать.
;; Файл с программой следует сохранить в определенную Вами папку так,		
;; чтобы Вы в последствии могли его без труда найти.
;; Для использования программы, ее следует загружать в каждый заново
;; открываемый документ.
;; Загрузить программу в открытый документ можно следующими способами:
;; для английского автокада:
;; Tools->Load Application->[указываем, если необходимо тип файлов *.lsp,
;; находим файл с программой]->Load
;; в этом же окошке можно использовать галочку "Add To History", посмотреть
;; вкладку "History List", а так же использовать "StartUp Suite"
;; в этом случае Вы добавите файл с программой в автозагрузку автокада
;; и Вам не придется каждый раз загружать программу в чертеж вручную.

(defun c:a>t ( / #actdoc)
  (setq #actdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (kd:attdefs>texts)
  (vla-endundomark #actdoc)
  (princ)
  );defun

(defun kd:attdefs>texts (/ atts #modspace)
  (defun ss->lsto* (ss / lsto)
    (setq lsto (reverse (ssnamex ss)))
    (while (listp (cadar lsto))
      (setq lsto (cdr lsto)))
    (mapcar '(lambda (x) (vlax-ename->vla-object (cadr x))) lsto)
    );defun
  
  (if (= 1 (vla-get-ActiveSpace #actdoc))
    (setq #modspace (vla-get-ModelSpace #actdoc))
    (setq #modspace (vla-get-block (vla-get-ActiveLayout #actdoc)))
    )
  
  (if (setq atts (ssget  '((0 . "ATTDEF"))))
    (progn
      (setq atts (ss->lsto* atts))
  (mapcar
    '(lambda (att / txto tmp)
       (if (= :vlax-false (vlax-get-property att "MTextAttribute"))
	(progn
	  (setq txto (vla-AddText #modspace "" (vlax-3D-Point '(0 0 0)) 2.5))
	  (vlax-put-property txto "Alignment" (setq tmp (vlax-get-property att "Alignment")))
	  (if (= tmp 0)
	    (vlax-put-property txto "InsertionPoint" (vlax-get-property att "InsertionPoint"))
	    (vlax-put-property txto "TextAlignmentPoint" (vlax-get-property att "TextAlignmentPoint"))
	    )
	  (vlax-put-property txto "Backward" (vlax-get-property att "Backward"))
	  (vlax-put-property txto "Height" (vlax-get-property att "Height"))
	  (vlax-put-property txto "Linetype" (vlax-get-property att "Linetype"))
	  (vlax-put-property txto "LinetypeScale" (vlax-get-property att "LinetypeScale"))
	  (vlax-put-property txto "ObliqueAngle" (vlax-get-property att "ObliqueAngle"))
	  (vlax-put-property txto "Rotation" (vlax-get-property att "Rotation"))
	  (vlax-put-property txto "ScaleFactor" (vlax-get-property att "ScaleFactor"))
	  (vlax-put-property txto "StyleName" (vlax-get-property att "StyleName"))
	  (vlax-put-property txto "Thickness" (vlax-get-property att "Thickness"))
	  (vlax-put-property txto "UpsideDown" (vlax-get-property att "UpsideDown"))
	  );if txt
        ;if mtext
	(progn
	  ;(setq att (vlax-ename->vla-object (car (nentsel))))
	  (setq txto (vla-AddMText #modspace (vlax-3D-Point '(0 0 0)) 0 ""))
	  (vlax-put-property txto "AttachmentPoint" (- (vlax-get-property att "Alignment") 5))
	  (vlax-put-property txto "InsertionPoint" (vlax-get-property att "TextAlignmentPoint"))
	  (vlax-put-property txto "Width" (vlax-get-property att "MTextBoundaryWidth"))
	  (vlax-put-property txto "DrawingDirection" (vlax-get-property att "MTextDrawingDirection"))
	  (vlax-put-property txto "LineSpacingStyle" 2)
	  (vlax-put-property txto "LineSpacingFactor" 0.84)
	  (vlax-put-property txto "Height" (vlax-get-property att "Height"))
	  ;(vlax-put-property txto "Rotation" (vlax-get-property att "Rotation"))
	  )
	);case mtext
       ;;;;; общие свойства для обоих
       (vlax-put-property txto "color" (vlax-get-property att "color"))
       (vlax-put-property txto "LineWeight" (vlax-get-property att "LineWeight"))
       (vlax-put-property txto "layer" (vlax-get-property att "layer"))
       (vla-put-Textstring txto (vla-get-TagString att))
       )
    atts
    )
      (princ (strcat "\n Преобразовано " (itoa (length atts)) " аттрибутов... Done.\n"))
      (mapcar 'vla-delete atts)
      )
    ;(princ)
    )
  );defun
















(defun c:t>a ( / #actdoc)
  (setq #actdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (vla-startundomark #actdoc)
  (kd:texts>attdefs)
  (vla-endundomark #actdoc)
  );defun

(defun kd:texts>attdefs (/ texts #modspace)
  (defun ss->lsto* (ss / lsto)
    (setq lsto (reverse (ssnamex ss)))
    (while (listp (cadar lsto))
      (setq lsto (cdr lsto)))
    (mapcar '(lambda (x) (vlax-ename->vla-object (cadr x))) lsto)
    );defun
  
  (if (= 1 (vla-get-ActiveSpace #actdoc))
    (setq #modspace (vla-get-ModelSpace #actdoc))
    (setq #modspace (vla-get-block (vla-get-ActiveLayout #actdoc)))
    )
  
  (if (setq texts (ssget '((0 . "*TEXT"))))
    (progn
      (setq texts (ss->lsto* texts))

      
  (mapcar
    '(lambda (text / atto tmp)	;(setq text (vlax-ename->vla-object (car (entsel))))
       (setq atto (vla-AddAttribute #modspace 1 1 "" (vlax-3D-Point '(0 0 0)) "$TAG" "##"))

       (if (= "AcDbMText" (vla-get-ObjectName text))
	 (progn
	   ;(vla-put-Mode atto acAttributeModeMultipleLine) 32
	   ;(vla-put-Mode atto acAttributeModeLockPosition)	16
	   ;(vla-put-Mode atto acAttributeModePreset)	8
	   (vla-put-mode atto 56)
	   (vlax-put-property atto "Alignment" (+ (vlax-get-property text "AttachmentPoint") 5))
	   (vlax-put-property atto "TextAlignmentPoint" (vlax-get-property text "InsertionPoint"))
	   (vlax-put-property atto "MTextBoundaryWidth" (vlax-get-property text "Width"))
	   (vlax-put-property atto "MTextDrawingDirection" (vlax-get-property text "DrawingDirection"))
	   ;	modent
	   ;(vlax-put-property atto "LineSpacingStyle" 2)
	   ;(vlax-put-property atto "LineSpacingFactor" 0.84)
	   )
	 (progn
	   (vla-put-mode atto 24)
	   (vlax-put-property atto "Alignment" (setq tmp (vlax-get-property text "Alignment")))
	   (if (= tmp 0)
	     (vlax-put-property atto "InsertionPoint" (vlax-get-property text "InsertionPoint"))
	     (vlax-put-property atto "TextAlignmentPoint" (vlax-get-property text "TextAlignmentPoint"))
	     )
	   (vlax-put-property atto "Backward" (vlax-get-property text "Backward"))
	   (vlax-put-property atto "Linetype" (vlax-get-property text "Linetype"))
	   (vlax-put-property atto "LinetypeScale" (vlax-get-property text "LinetypeScale"))
	   (vlax-put-property atto "ObliqueAngle" (vlax-get-property text "ObliqueAngle"))
	   (vlax-put-property atto "ScaleFactor" (vlax-get-property text "ScaleFactor"))
	   (vlax-put-property atto "StyleName" (vlax-get-property text "StyleName"))
	   (vlax-put-property atto "Thickness" (vlax-get-property text "Thickness"))
	   (vlax-put-property atto "UpsideDown" (vlax-get-property text "UpsideDown"))
	   )
	 );if mtxt
       
       (vlax-put-property atto "Height" (vlax-get-property text "Height"))
       (vlax-put-property atto "Rotation" (vlax-get-property text "Rotation"))
       (vlax-put-property atto "color" (vlax-get-property text "color"))
       (vlax-put-property atto "LineWeight" (vlax-get-property text "LineWeight"))
       (vlax-put-property atto "layer" (vlax-get-property text "layer"))

       (vlax-put-property atto "PromptString" (vlax-get-property text "Textstring"))
       )
    texts
    )
      (princ (strcat "\n Преобразовано " (itoa (length texts)) " аттрибутов... Done.\n"))
      (mapcar 'vla-delete texts)
      )
    )
  );defun