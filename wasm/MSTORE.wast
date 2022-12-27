;; stack:
;;  0: word
;; -1: offset
(func $MSTORE
  (local $sp i32)

  (local $offset   i32)
  
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
  ;; subtrace gas useage
  (call $memusegas (local.get $offset) (i32.const 32))

  ;; pop item from the stack
  (local.set $sp (i32.sub (global.get $sp) (i32.const 32)))

  ;; swap top stack item
  (drop (call $bswap_m256 (local.get $sp)))

  (local.set $offset (i32.add (local.get $offset) (global.get $memstart)))
  ;; store word to memory
  (i64.store          (local.get $offset)                 (i64.load          (local.get $sp)))
  (i64.store (i32.add (local.get $offset) (i32.const 8))  (i64.load (i32.add (local.get $sp) (i32.const  8))))
  (i64.store (i32.add (local.get $offset) (i32.const 16)) (i64.load (i32.add (local.get $sp) (i32.const 16))))
  (i64.store (i32.add (local.get $offset) (i32.const 24)) (i64.load (i32.add (local.get $sp) (i32.const 24))))
)
