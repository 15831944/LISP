(setq ifxml (vla-getinterfaceobject #cad "xmlfile"))


IXMLDOMText
(setq ifxml (vla-getinterfaceobject #cad "MSXML"))
(setq app (vlax-get-or-create-object "MSXML"))




(vlax-invoke-method ifxml "createElement"
  vlax-vbstring
  (vlax-make-variant
    (vlax-safearray-fill
      (vlax-make-safearray
	vlax-vbstring
	'(0 . 0)) '("asd")))
  )


(setq ifxml (vla-getinterfaceobject #cad "xmlfile"))


(setq ifxml (vla-getinterfaceobject #cad "Microsoft.XMLDOM"))
(setq ifxml (vla-getinterfaceobject #cad "Microsoft.XMLDOM"))


(vlax-invoke-method ifxml "save" "D:\\asd.xml")
(setq el (vlax-invoke-method ifxml "createElement" "el"))
(vlax-invoke-method ifxml "appendChild" el)