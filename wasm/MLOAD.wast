;; stack:
;;  0: offset
(func $MLOAD
  (local $offset i32)
  (local $offset0 i64)
  (local $offset1 i64)
  (local $offset2 i64)
  (local $offset3 i64)

  ;; load args from the stack
  (local.set $offset0 (i64.load          (global.get $sp)))
  (local.set $offset1 (i64.load (i32.add (global.get $sp) (i32.const 8))))
  (local.set $offset2 (i64.load (i32.add (global.get $sp) (i32.const 16))))
  (local.set $offset3 (i64.load (i32.add (global.get $sp) (i32.const 24))))

  (local.set $offset 
             (call $check_overflow (local.get $offset0)
                                   (local.get $offset1)
                                   (local.get $offset2)
                                   (local.get $offset3)))
  ;; subttract gas useage
  (call $memusegas (local.get $offset) (i32.const  32))

  ;; FIXME: how to deal with overflow?
  (local.set $offset (i32.add (local.get $offset) (global.get $memstart)))

  (i64.store (i32.add (global.get $sp) (i32.const 24)) (i64.load (i32.add (local.get $offset) (i32.const 24))))
  (i64.store (i32.add (global.get $sp) (i32.const 16)) (i64.load (i32.add (local.get $offset) (i32.const 16))))
  (i64.store (i32.add (global.get $sp) (i32.const  8)) (i64.load (i32.add (local.get $offset) (i32.const  8))))
  (i64.store          (global.get $sp)                 (i64.load          (local.get $offset)))

  ;; swap
  (drop (call $bswap_m256 (global.get $sp)))
)
