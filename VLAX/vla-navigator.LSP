(defun vlax-nav (
		 /
		 obj
		 apl		; all property list
		 cpl		; current propery list

		 
		 kword
		 init
		 key
		 flag
		 )
  (setq cad (vlax-get-acad-object))
  (setq actdoc (vla-get-activedocument cad))
  (setq flag T
	apl (list
	    "ACTIVE"
	    "ACTIVEDIMSTYLE"
	    "ACTIVEDOCUMENT"
	    "ACTIVELAYER"
	    "ACTIVELAYOUT"
	    "ACTIVELINETYPE"
	    "ACTIVEPROFILE"
	    ;"ACTIVEPVIEWPORT"
	    "ACTIVESELECTIONSET"
	    "ACTIVESPACE"
	    "ACTIVETEXTSTYLE"
	    "ACTIVEUCS"
	    "ACTIVEVIEWPORT"
	    "ALIGNMENT"
	    "ALIGNMENTPOINTACQUISITION"
	    "ALLOWLONGSYMBOLNAMES"
	    "ALTFONTFILE"
	    "ALTROUNDDISTANCE"
	    "ALTSUPPRESSLEADINGZEROS"
	    "ALTSUPPRESSTRAILINGZEROS"
	    "ALTSUPPRESSZEROFEET"
	    "ALTSUPPRESSZEROINCHES"
	    "ALTTABLETMENUFILE"
	    "ALTTEXTPREFIX"
	    "ALTTEXTSUFFIX"
	    "ALTTOLERANCEPRECISION"
	    "ALTTOLERANCESUPPRESSLEADINGZEROS"
	    "ALTTOLERANCESUPPRESSTRAILINGZEROS"
	    "ALTTOLERANCESUPPRESSZEROFEET"
	    "ALTTOLERANCESUPPRESSZEROINCHES"
	    "ALTUNITS"
	    "ALTUNITSFORMAT"
	    "ALTUNITSPRECISION"
	    "ALTUNITSSCALE"
	    "ANGLE"
	    "ANGLEFORMAT"
	    "ANGLEVERTEX"
	    "ANNOTATION"
	    "APPLICATION"
	    "ARCLENGTH"
	    "ARCSMOOTHNESS"
	    "AREA"
	    "ARROWHEAD1BLOCK"
	    "ARROWHEAD1TYPE"
	    "ARROWHEAD2BLOCK"
	    "ARROWHEAD2TYPE"
	    "ARROWHEADBLOCK"
	    "ARROWHEADSIZE"
	    "ARROWHEADTYPE"
	    "ASSOCIATIVEHATCH"
	    "ATTACHMENTPOINT"
	    "AUTOAUDIT"
	    "AUTOSAVEINTERVAL"
	    "AUTOSAVEPATH"
	    "AUTOSNAPAPERTURE"
	    "AUTOSNAPAPERTURESIZE"
	    "AUTOSNAPMAGNET"
	    "AUTOSNAPMARKER"
	    "AUTOSNAPMARKERCOLOR"
	    "AUTOSNAPMARKERSIZE"
	    "AUTOSNAPTOOLTIP"
	    "AUTOTRACKINGVECCOLOR"
	    "AUTOTRACKTOOLTIP"
	    "BACKWARD"
	    "BASEPOINT"
	    "BATCHPLOTPROGRESS"
	    "BEEPONERROR"
	    "BIGFONTFILE"
	    "BLOCK"
	    "BLOCKS"
	    "BRIGHTNESS"
	    "CANONICALMEDIANAME"
	    "CAPTION"
	    "CEINSERTUNITS"
	    "CEINSERTUNITSACTION"
	    "CELOADPALETTE"
	    "CENTER"
	    "CENTERMARKSIZE"
	    "CENTERPLOT"
	    "CENTERTYPE"
	    "CENTROID"
	    "CHECK"
	    "CIRCUMFERENCE"
	    "CLIPPED"
	    "CLIPPINGENABLED"
	    "CLOSED"
	    "COLOR"
	    "COLUMNS"
	    "COLUMNSPACING"
	    "CONFIGFILE"
	    "CONFIGNAME"
	    "CONSTANT"
	    "CONSTANTWIDTH"
	    "CONTOURLINESPERSURFACE"
	    "CONTRAST"
	    "CONTROLPOINTS"
	    "COORDINATE"
	    "COORDINATES"
	    "COUNT"
	    "CREATEBACKUP"
	    "CURSORSIZE"
	    "CUSTOMDICTIONARY"
	    "CUSTOMSCALE"
	    "DATABASE"
	    "DECIMALSEPARATOR"
	    "DEFAULTINTERNETURL"
	    "DEFAULTOUTPUTDEVICE"
	    "DEFAULTPLOTSTYLEFORLAYERS"
	    "DEFAULTPLOTSTYLEFOROBJECTS"
	    "DEGREE"
	    "DELTA"
	    "DEMANDLOADARXAPP"
	    "DESCRIPTION"
	    "DIAMETER"
	    "DICTIONARIES"
	    "DIMENSIONLINECOLOR"
	    "DIMENSIONLINEEXTEND"
	    "DIMENSIONLINEWEIGHT"
	    "DIMLINE1SUPPRESS"
	    "DIMLINE2SUPPRESS"
	    "DIMLINEINSIDE"
	    "DIMLINESUPPRESS"
	    "DIMSTYLES"
	    "DIRECTION"
	    "DIRECTIONVECTOR"
	    "DISPLAY"
	    "DISPLAYDRAGGEDOBJECT"
	    "DISPLAYGRIPS"
	    "DISPLAYGRIPSWITHINBLOCKS"
	    "DISPLAYLAYOUTTABS"
	    "DISPLAYLOCKED"
	    "DISPLAYOLESCALE"
	    "DISPLAYSCREENMENU"
	    "DISPLAYSCROLLBARS"
	    "DISPLAYSILHOUETTE"
	    "DOCKEDVISIBLELINES"
	    "DOCKSTATUS"
	    "DOCUMENTS"
	    "DRAFTING"
	    "DRAWINGDIRECTION"
	    "DRIVERSPATH"
	    "ELEVATION"
	    "ELEVATIONMODELSPACE"
	    "ELEVATIONPAPERSPACE"
	    "ENABLE"
	    "ENABLESTARTUPDIALOG"
	    "ENDANGLE"
	    "ENDPARAMETER"
	    "ENDPOINT"
	    "ENDTANGENT"
	    "EXTENSIONLINECOLOR"
	    "EXTENSIONLINEEXTEND"
	    "EXTENSIONLINEOFFSET"
	    "EXTENSIONLINEWEIGHT"
	    "EXTLINE1ENDPOINT"
	    "EXTLINE1POINT"
	    "EXTLINE1STARTPOINT"
	    "EXTLINE1SUPPRESS"
	    "EXTLINE2ENDPOINT"
	    "EXTLINE2POINT"
	    "EXTLINE2STARTPOINT"
	    "EXTLINE2SUPPRESS"
	    "FADE"
	    "FIELDLENGTH"
	    "FILES"
	    "FIT"
	    "FITPOINTS"
	    "FITTOLERANCE"
	    "FLOATINGROWS"
	    "FLYOUT"
	    "FONTFILE"
	    "FONTFILEMAP"
	    "FORCELINEINSIDE"
	    "FRACTIONFORMAT"
	    "FREEZE"
	    "FULLCRCVALIDATION"
	    "FULLNAME"
	    "FULLSCREENTRACKINGVECTOR"
	    "GRAPHICSWINLAYOUTBACKGRNDCOLOR"
	    "GRAPHICSWINMODELBACKGRNDCOLOR"
	    "GRIDON"
	    "GRIPCOLORSELECTED"
	    "GRIPCOLORUNSELECTED"
	    "GRIPSIZE"
	    "GROUPS"
	    "HANDLE"
	    "HASATTRIBUTES"
	    "HASEXTENSIONDICTIONARY"
	    "HATCHSTYLE"
	    "HEIGHT"
	    "HELPFILEPATH"
	    "HELPSTRING"
	    "HISTORYLINES"
	    "HORIZONTALTEXTPOSITION"
	    "HWND"
	    "HYPERLINKDISPLAYCURSOR"
	    "HYPERLINKDISPLAYTOOLTIP"
	    "HYPERLINKS"
	    "IMAGEFILE"
	    "IMAGEFRAMEHIGHLIGHT"
	    "IMAGEHEIGHT"
	    "IMAGEVISIBILITY"
	    "IMAGEWIDTH"
	    "INCREMENTALSAVEPERCENT"
	    "INDEX"
	    "INSERTIONPOINT"
	    "INVISIBLE"
	    "ISLAYOUT"
	    "ISOPENWIDTH"
	    "ISPERIODIC"
	    "ISPLANAR"
	    "ISRATIONAL"
	    "ISXREF"
	    "KEYBOARDACCELERATOR"
	    "KEYBOARDPRIORITY"
	    "KNOTS"
	    "LABEL"
	    "LARGEBUTTONS"
	    "LASTHEIGHT"
	    "LAYER"
	    "LAYERON"
	    "LAYERS"
	    "LAYOUT"
	    "LAYOUTCREATEVIEWPORT"
	    "LAYOUTCROSSHAIRCOLOR"
	    "LAYOUTDISPLAYMARGINS"
	    "LAYOUTDISPLAYPAPER"
	    "LAYOUTDISPLAYPAPERSHADOW"
	    "LAYOUTS"
	    "LAYOUTSHOWPLOTSETUP"
	    "LEADERLENGTH"
	    "LEFT"
	    "LEGACYSTYLESHEET"
	    "LENGTH"
	    "LENSLENGTH"
	    "LICENSESERVER"
	    "LIMITS"
	    "LINEARSCALEFACTOR"
	    "LINESPACINGFACTOR"
	    "LINESPACINGSTYLE"
	    "LINETYPE"
	    "LINETYPEGENERATION"
	    "LINETYPES"
	    "LINETYPESCALE"
	    "LINEWEIGHT"
	    "LOCALEID"
	    "LOCK"
	    "LOGFILEON"
	    "LOGFILEPATH"
	    "LOWERLEFTCORNER"
	    "MACRO"
	    "MAINDICTIONARY"
	    "MAJORAXIS"
	    "MAJORRADIUS"
	    "MAXACTIVEVIEWPORTS"
	    "MAXAUTOCADWINDOW"
	    "MAXNUMOFSYMBOLS"
	    "MCLOSE"
	    "MDENSITY"
	    "MEASUREMENT"
	    "MEASUREMENTUNITS"
	    "MENUBAR"
	    "MENUFILE"
	    "MENUFILENAME"
	    "MENUGROUPS"
	    "MENUS"
	    "MINORAXIS"
	    "MINORRADIUS"
	    "MODE"
	    "MODELCROSSHAIRCOLOR"
	    "MODELSPACE"
	    "MODELTYPE"
	    "MOMENTOFINERTIA"
	    "MONOCHROMEVECTORS"
	    "MRUNUMBER"
	    "MSPACE"
	    "MVERTEXCOUNT"
	    "NAME"
	    "NAMENOMNEMONIC"
	    "NCLOSE"
	    "NDENSITY"
	    "NORMAL"
	    "NUMBEROFCONTROLPOINTS"
	    "NUMBEROFCOPIES"
	    "NUMBEROFFACES"
	    "NUMBEROFFITPOINTS"
	    "NUMBEROFLOOPS"
	    "NUMBEROFVERTICES"
	    "NVERTEXCOUNT"
	    "OBJECTARXPATH"
	    "OBJECTID"
	    "OBJECTNAME"
	    "OBJECTSNAPMODE"
	    "OBJECTSORTBYPLOTTING"
	    "OBJECTSORTBYPSOUTPUT"
	    "OBJECTSORTBYREDRAWS"
	    "OBJECTSORTBYREGENS"
	    "OBJECTSORTBYSELECTION"
	    "OBJECTSORTBYSNAP"
	    "OBLIQUEANGLE"
	    "OLELAUNCH"
	    "OLEQUALITY"
	    "ONMENUBAR"
	    "OPENSAVE"
	    "ORIGIN"
	    "ORTHOENABLED"
	    "ORTHOON"
	    "OUTPUT"
	    "OwnerID"
	    "PAPERSPACE"
	    "PAPERUNITS"
	    "PARENT"
	    "PATH"
	    "PATTERNANGLE"
	    "PATTERNDOUBLE"
	    "PATTERNNAME"
	    "PATTERNSCALE"
	    "PATTERNSPACE"
	    "PATTERNTYPE"
	    "PERIMETER"
	    "PICKADD"
	    "PICKAUTO"
	    "PICKBOXSIZE"
	    "PICKDRAG"
	    "PICKFIRST"
	    "PICKFIRSTSELECTIONSET"
	    "PICKGROUP"
	    "PLOT"
	    "PLOTCONFIGURATIONS"
	    "PLOTHIDDEN"
	    "PLOTLEGACY"
	    "PLOTORIGIN"
	    "PLOTPOLICYFORLEGACYDWGS"
	    "PLOTPOLICYFORNEWDWGS"
	    "PLOTROTATION"
	    "PLOTSTYLENAME"
	    "PLOTSTYLESHEET"
	    "PLOTTABLE"
	    "PLOTTYPE"
	    "PLOTVIEWPORTBORDERS"
	    "PLOTVIEWPORTSFIRST"
	    "PLOTWITHLINEWEIGHTS"
	    "PLOTWITHPLOTSTYLES"
	    "POLARTRACKINGVECTOR"
	    "POSTSCRIPTPROLOGFILE"
	    "PREFERENCES"
	    "PRESET"
	    "PRIMARYUNITSPRECISION"
	    "PRINCIPALDIRECTIONS"
	    "PRINCIPALMOMENTS"
	    "PRINTERCONFIGPATH"
	    "PRINTERDESCPATH"
	    "PRINTERPAPERSIZEALERT"
	    "PRINTERSPOOLALERT"
	    "PRINTERSTYLESHEETPATH"
	    "PRINTFILE"
	    "PRINTSPOOLERPATH"
	    "PRINTSPOOLEXECUTABLE"
	    "PRODUCTOFINERTIA"
	    "PROFILES"
	    "PROMPTSTRING"
	    "PROXYIMAGE"
	    "QUIETERRORMODE"
	    "RADIIOFGYRATION"
	    "RADIUS"
	    "RADIUSRATIO"
	    "READONLY"
	    "REGISTEREDAPPLICATIONS"
	    "REMOVEHIDDENLINES"
	    "RENDERSMOOTHNESS"
	    "ROTATION"
	    "ROUNDDISTANCE"
	    "ROWS"
	    "ROWSPACING"
	    "SAVEASTYPE"
	    "SAVED"
	    "SAVEPREVIEWTHUMBNAIL"
	    "SCALEFACTOR"
	    "SCALELINEWEIGHTS"
	    "SECONDPOINT"
	    "SEGMENTPERPOLYLINE"
	    "SELECTION"
	    "SELECTIONSETS"
	    "SHORTCUTMENU"
	    "SHOWPLOTSTYLES"
	    "SHOWPROXYDIALOGBOX"
	    "SHOWRASTERIMAGE"
	    "SHOWWARNINGMESSAGES"
	    "SINGLEDOCUMENTMODE"
	    "SNAPBASEPOINT"
	    "SNAPON"
	    "SNAPROTATIONANGLE"
	    "SOLIDCHECK"
	    "SOLIDFILL"
	    "STANDARDSCALE"
	    "STARTANGLE"
	    "STARTPARAMETER"
	    "STARTPOINT"
	    "STARTTANGENT"
	    ;"STATUSID"
	    "STORESQLINDEX"
	    "STYLENAME"
	    "STYLESHEET"
	    "SUBMENU"
	    "SUPPORTPATH"
	    "SUPPRESSLEADINGZEROS"
	    "SUPPRESSTRAILINGZEROS"
	    "SUPPRESSZEROFEET"
	    "SUPPRESSZEROINCHES"
	    "SYSTEM"
	    "TABLESREADONLY"
	    "TABORDER"
	    "TAGSTRING"
	    "TARGET"
	    "TEMPFILEEXTENSION"
	    "TEMPFILEPATH"
	    "TEMPLATEDWGPATH"
	    "TEMPXREFPATH"
	    "TEXTALIGNMENTPOINT"
	    "TEXTCOLOR"
	    "TEXTEDITOR"
	    "TEXTFONT"
	    "TEXTFONTSIZE"
	    "TEXTFONTSTYLE"
	    "TEXTFRAMEDISPLAY"
	    "TEXTGAP"
	    "TEXTGENERATIONFLAG"
	    "TEXTHEIGHT"
	    "TEXTINSIDE"
	    "TEXTINSIDEALIGN"
	    "TEXTMOVEMENT"
	    "TEXTOUTSIDEALIGN"
	    "TEXTOVERRIDE"
	    "TEXTPOSITION"
	    "TEXTPRECISION"
	    "TEXTPREFIX"
	    "TEXTROTATION"
	    "TEXTSTRING"
	    "TEXTSTYLE"
	    "TEXTSTYLES"
	    "TEXTSUFFIX"
	    "TEXTUREMAPPATH"
	    "TEXTWINBACKGRNDCOLOR"
	    "TEXTWINTEXTCOLOR"
	    "THICKNESS"
	    "TOLERANCEDISPLAY"
	    "TOLERANCEHEIGHTSCALE"
	    "TOLERANCEJUSTIFICATION"
	    "TOLERANCELOWERLIMIT"
	    "TOLERANCEPRECISION"
	    "TOLERANCESUPPRESSLEADINGZEROS"
	    "TOLERANCESUPPRESSTRAILINGZEROS"
	    "TOLERANCESUPPRESSZEROFEET"
	    "TOLERANCESUPPRESSZEROINCHES"
	    "TOLERANCEUPPERLIMIT"
	    "TOOLBARS"
	    "TOP"
	    "TOTALANGLE"
	    "TRANSLATEIDS"
	    "TRANSPARENCY"
	    "TRUECOLORIMAGES"
	    "TWISTANGLE"
	    "TYPE"
	    "UCSICONATORIGIN"
	    "UCSICONON"
	    "UCSPERVIEWPORT"
	    "UNITSFORMAT"
	    "UPPERRIGHTCORNER"
	    "UPSIDEDOWN"
	    "URL"
	    "URLDESCRIPTION"
	    "USER"
	    "USERCOORDINATESYSTEMS"
	    "USESTANDARDSCALE"
	    "UTILITY"
	    "VBE"
	    "VERIFY"
	    "VERSION"
	    "VERTICALTEXTPOSITION"
	    "VIEWPORTDEFAULT"
	    "VIEWPORTON"
	    "VIEWPORTS"
	    "VIEWS"
	    "VIEWTOPLOT"
	    "VISIBILITYEDGE1"
	    "VISIBILITYEDGE2"
	    "VISIBILITYEDGE3"
	    "VISIBILITYEDGE4"
	    "VISIBLE"
	    "VOLUME"
	    "WEIGHTS"
	    "WIDTH"
	    "WINDOWSTATE"
	    "WINDOWTITLE"
	    "WORKSPACEPATH"
	    "XREFDATABASE"
	    "XREFDEMANDLOAD"
	    "XREFEDIT"
	    "XREFFADEINTENSITY"
	    "XREFLAYERVISIBILITY"
	    "XSCALEFACTOR"
	    "XVECTOR"
	    "YSCALEFACTOR"
	    "YVECTOR"
	    "ZSCALEFACTOR"
	    ) ;_ list
      ) ;setq
  (setq obj (vlax-ename->vla-object (car (entsel))))

(while flag
  (setq	cpl '()
;;;	init ""
;;;	kword ""
	) ;_ setq

  (foreach item	apl
    (if	(and
	  (= 'VLA-OBJECT (type obj))
	  (vlax-property-available-p obj item)
	  ) ;_ and
      (progn
	(setq cpl (append cpl (list item)))
;;;	(setq init (strcase (strcat init (vl-string-subst "-" "_" item) " ") t))
;;;	(setq kword (strcase (strcat kword (vl-string-subst "-" "_" item) "/") t))
 	) ;progn
      ) ;if
    ) ;_ foreach

  
(if (and
      (= 'VLA-OBJECT (type obj))
      (> (length cpl) 0)
      )
  (progn
;;;    (setq kword (strcat "”кажите свойство: [" kword "] :"))
;;;    (princ "\n    ЁЋ≈ћ≈Ќ“\n********************************************************************\n")
;;;    (princ obj)
;;;    (princ "\n********************************************************************\n")
;;;;;;================================================================================
;;;    (princ "\n-----------------------------------------------------------------\n")
;;;;;;    (mapcar '(lambda (x / func)
;;;;;;	       (princ x)
;;;;;;	       (princ "\t")
;;;;;;	       (princ "=")
;;;;;;	       (princ "\t")
;;;;;;	       (setq func (read (strcat "VLA-GET-" x)))
;;;;;;	       ;(if (vlax-method-applicable-p obj func)
;;;;;;		 (princ (eval (list func obj)))
;;;;;;		; )
;;;;;;	       (princ "\n")
;;;;;;	       ) ;_ lambda
;;;;;;	    cpl
;;;;;;	    ) ;_ mapcar
;;;    (vlax-dump-object obj T)
;;;    (princ "\n-----------------------------------------------------------------\n") ;_ princ
;;;
;;;    (initget (strcat init " _" init))
;;;    (setq key (strcat "VLA-GET-" (getkword kword)))
;;;    (princ "\n")
;;;    (setq obj (eval (list (read key) obj)))

  ;;;;*******************************************************************
    

    (princ "\n\n\n")
    (vlax-dump-object obj)

    (if (setq key (getprop cpl))
      (progn
	(setq key (strcat "VLA-GET-" (nth (read key) cpl)))
	(setq obj (eval (list (read key) obj)))
	);progn
      );if




    
    ) ;progn
  (progn
    (setq flag nil)
    (princ obj)
    (princ)
    )
  ) ;if
  
  ) ;while
  );defun





























(defun getprop (cpl
		/
		dlgname
		dlgfname
		dcl-file-path			; путь к dcl-файлу дл€ проги (в папку temp)
		hand					; ручка этого файла
		dcl_id
		str
		prop
		)

  (setq
    dlgname "vlax_nav_dlg"
    dlgfname "vlax-navigator.dcl"
    dcl-file-path (strcat (getenv "temp") "\\")
    hand (open (strcat dcl-file-path dlgfname) "w"))

  (setq str "")
  (foreach item cpl
    (setq str (strcat str item "\\n"))
    )
  
  ;;; генераци€ dcl-файла
  
  (foreach item
	   (list
	     dlgname
	     ": dialog"
	     "{label=\"vlax-navigator by ktz\";"
	     "width=80;"
	     ":list_box{"
	     (strcat "label=\"доступные свойства объекта "
		     ;()
		     "\";" )
	     "key=\"lstbox\";"
		(strcat "list=\""
	     ;јттрибут 1\nјттрибут 2\nјттрибут 3\n
		
	     str
	     "\";");strcat
		"fixed_width_font=false;"
		"}"
		":spacer{width=1;}"
		"ok_cancel;"
		"}"
	     )
    (write-line item hand)
    );foreach
  (close hand)


  (if (< (setq dcl_id (load_dialog (strcat dcl-file-path dlgfname))) 0)
    (exit)
    ) ;if

  (if (not (new_dialog dlgname dcl_id))
    (exit)
    ) ;_ конец if
  
  
  (action_tile
    "lstbox"
    (strcat    
    "(setq prop (get_tile \"lstbox\"))"
    "(done_dialog)"
    )
    )
 
  (action_tile
    "is_default"
    (strcat    
    "(setq prop nil)"
    "(done_dialog)"
    )
    )
  (start_dialog)
  (unload_dialog dcl_id)
  prop
  );defun




;XOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXO
;OXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOX
;XOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXO
;OXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOX
;XOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXO
;OXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOX
;XOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXO
;OXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOX
;XOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXO
;OXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOXOX
(do (vlax-ename->vla-object (car (entsel))))
(setq v (vla-GetAttributes obj))
(vlax-safearray->list (vlax-variant-value v))


(defun vlxnav (
	       /
	       obj
	       allproplist
	       methodlist
	       methtoapply
	       noerrorsflag
	       key
	       )
  (setq cad (vlax-get-acad-object))
  (setq actdoc (vla-get-activedocument cad))
  (setq obj (vlax-ename->vla-object (car (entsel))))
  (princ "\n\n\n")
  (vlax-dump-object obj T)
  (setq noerrorsflag T)
  (setq allproplist (list
		      "OwnerID"
		      "Count"
		      ))
  (setq methodlist (list
		      "Item"
		      "GetAttributes"
		      "GetConstantAttributes"
		      "GetDynamicBlockProperties"
		      "GetExtensionDictionary"
		      ))
  (while noerrorsflag
    (setq methtoapply '())

  (foreach item	methodlist
    (if	(and (= 'VLA-OBJECT (type obj)) (vlax-method-applicable-p obj item))
	(setq methtoapply (append methtoapply (list item)))
      );if
    )


  (if (and (= 'VLA-OBJECT (type obj)) (> (length  methtoapply) 0))
    ;then
    (progn
      (setq key (dclgetitemfromlist methtoapply))
      (setq key (strcat "VLA-" (nth key methtoapply)))
      (if (= (strcase key) "VLA-ITEM")
	(setq obj (eval (list (read key) obj (getint "\nselect number"))))
	(setq obj (eval (list (read key) obj)))
	)
	(princ "\n\n\n")
	(vlax-dump-object obj T)
      );then
    ;else
    (progn
      (setq noerrorsflag nil)
      (princ obj)
      (princ)
      )
    );if there are avalible methods
    );while noerrorsflag
  );defun














;(dclgetitemfromlist '("a" "b" "c" "d"))

(defun dclgetitemfromlist (lst /
			   dlgname
			   dlgfname
			   dcl-file-path
			   hand	
			   dcl-id
			   str
			   prop
			   )

  (setq
    dlgname "dclgetitemfromlist_dlg"
    dlgfname "dclgetitemfromlist.dcl"
    dcl-file-path (strcat (getenv "temp") "\\")
    hand (open (strcat dcl-file-path dlgfname) "w"))
  (setq str "")
  (foreach item lst
    (setq str (strcat str item "\\n"))
    )
  (foreach item (list
		  dlgname
		  ": dialog"
		  "{label=\"dclgetitemfromlist by ktz\";"
		  "width=80;"
		  ":list_box{"
		  	"label=\"доступные варианты выбора \";"
		  	"key=\"lstbox\";"
		  	(strcat "list=\"" str "\";")
		  	"fixed_width_font=false;"
		  	"}"
		  ":spacer{width=1;}"
		  "ok_cancel;"
		  "}"
	     )
    (write-line item hand)
    );foreach
  (close hand)


  (if (or (< (setq dcl-id (load_dialog (strcat dcl-file-path dlgfname))) 0)
	  (not (new_dialog dlgname dcl-id)))
    (exit));if
  
  (action_tile "lstbox"
    (strcat    
    "(setq prop (get_tile \"lstbox\"))"
    "(done_dialog)"
    )
    )
 
  (action_tile "is_default"
    (strcat    
    "(setq prop nil)"
    "(done_dialog)"
    )
    )
  (start_dialog)
  (unload_dialog dcl-id)
  (atoi prop)
  );defun
