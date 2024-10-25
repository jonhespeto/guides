((workstation
  (title . "Setup for workstation")
  (action . trivial)
  (actiondata  ("/" (size 41943040 . 41943040) (fsim . "Ext2/3") (methods plain))  ; 40 GB для /
               ("/home" (size 1024000 . #t) (fsim . "Ext2/3") (methods plain))))
)