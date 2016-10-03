
;;;(vla-GetXRecordData (vla-item (vla-item dicts "MCS_STREAM_DICT") "MCS_DOCUMENT_ID") 'a 'b)
;;;(vlax-safearray->list a) ; (1001 1071 1004)
;;;(vlax-safearray->list b) ; (#<variant 8 MCS_DOCUMENT_ID> #<variant 3 45> #<variant 8209 >)
;;;(mapcar 'vlax-variant-value (vlax-safearray->list b)) ; ("MCS_DOCUMENT_ID" 45 #<safearray...>)
;;;(vlax-safearray->list (last (mapcar 'vlax-variant-value (vlax-safearray->list b))))
;;;;(4099 4096 4096 4096 4096 4096 4096 4096 4117 4096 4096 4096 4120 4096 4097 4096 4323 4100 4096 4096 4096 4096 4096 4096 4109 4116 4286 4179 4265 4184 4178 4131 4170 4271 4115 4247 4318 4299 4289 4191 4225 4351 4351 4351 4351) 


(defun variantextraction (var)
  (cond
    ((= 'LIST (type var)) (mapcar 'variantextraction var))
    ((= 'safearray (type var)) (variantextraction (vlax-safearray->list var)))
    ((= 'variant (type var)) (variantextraction (vlax-variant-value var)))
    (T var)
    )
  );defun


;;;  (variantextraction b)

