;; stack:
;;  0: dataOffset
(func $CALLDATALOAD
  (local $writeOffset i32)
  (local $writeOffset0 i64)
  (local $writeOffset1 i64)
  (local $writeOffset2 i64)
  (local $writeOffset3 i64)

  (local.set $writeOffset0 (i64.load (i32.add (global.get $sp) (i32.const  0))))
  (local.set $writeOffset1 (i64.load (i32.add (global.get $sp) (i32.const  8))))
  (local.set $writeOffset2 (i64.load (i32.add (global.get $sp) (i32.const 16))))
  (local.set $writeOffset3 (i64.load (i32.add (global.get $sp) (i32.const 24))))

  (i64.store (i32.add (global.get $sp) (i32.const  0)) (i64.const 0))
  (i64.store (i32.add (global.get $sp) (i32.const  8)) (i64.const 0))
  (i64.store (i32.add (global.get $sp) (i32.const 16)) (i64.const 0))
  (i64.store (i32.add (global.get $sp) (i32.const 24)) (i64.const 0))

  (local.set $writeOffset
             (call $check_overflow (local.get $writeOffset0)
                                   (local.get $writeOffset1)
                                   (local.get $writeOffset2)
                                   (local.get $writeOffset3)))

  (call $callDataCopy (global.get $sp) (local.get $writeOffset) (i32.const 32))
  ;; swap top stack item
  (drop (call $bswap_m256 (global.get $sp)))
)
