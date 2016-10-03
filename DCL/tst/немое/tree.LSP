(defun c:tree (/ dcl_id)
  (if (< (setq dcl_id (load_dialog "d:/LISP WORKING/DCL/tst/немое/fir-tree.DCL")
	 )
	 0
      )
    (exit)
  )
  (new_dialog "tree_dial" dcl_id)
  (start_image "tree")
  (mapcar (function (lambda (x) (apply 'vector_image x)))
	 '((29 29 4 29 1) (4 4 29 4 1) (4 29 29 4 1) (29 29 23 25 1) (29 29 23 32 1) (14 
4 8 0 1) (14 4 8 7 1) (7 14 10 9 1) (10 14 7 9 1) (13 9 14 11 1) (16 9 13 14 1) 
(11 11 13 11 1))

  )
  (end_image)
  (action_tile
    "accept"
    "(done_dialog)"
  )
  (start_dialog)
  (unload_dialog dcl_id)
)
