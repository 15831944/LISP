

(load (strcat #lisppath "common functions\\kd-container-list.LSP"))

(setq lays (vla-get-Layers #actdoc))
(setq lname (kd:dcl:pick-from-list (mapcar 'vla-get-name (KD-CONTAINER->LIST lays))))
(setq layertochange (vla-item lays lname))
(do layertochange)

(setq proplist '(
		 "Description"
		 "Freeze"
		 "LayerOn"
		 "Linetype"
		 "Lineweight"
		 "Lock"
		 "Material"
		 "PlotStyleName"
		 "Plottable"
		 "TrueColor"
		 ))
(setq docs (vla-get-Documents #cad))
(setq doc (vla-item docs (kd:dcl:pick-from-list (mapcar 'vla-get-name (KD-CONTAINER->LIST docs)))))

(setq layer-from-props-to-get (vla-item (vla-get-Layers doc) lname))

(foreach property proplist
  (if (vlax-property-available-p layer-from-props-to-get property)
    (vlax-put-property layertochange property
      (vlax-get-property layer-from-props-to-get property)
      )
    )
  )


(vlax-get-property layer-from-props-to-get "PlotStyleName")
(vlax-get-property layertochange "PlotStyleName")

(vlax-put-property layertochange "PlotStyleName"
      (vlax-get-property layer-from-props-to-get "PlotStyleName")
      )