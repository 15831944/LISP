(vlax-dump-object
    (vla-get-Utility
      (vla-get-Activedocument
	(vlax-get-acad-object)
	)
      )
    T
  )

(vla-GetInteger
    (vla-get-Utility
      (vla-get-Activedocument
	(vlax-get-acad-object)
	)
      )
    x
  )