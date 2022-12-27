;; stack:
;;  0: offset
;; -1: value
(func $BYTE
  (local $sp i32)

  (local $a0 i64)
  (local $a1 i64)
  (local $a2 i64)
  (local $a3 i64)
  (local.set $sp (global.get $sp))

  (local.set $a0 (i64.load (i32.add (local.get $sp) (i32.const 24))))
  (local.set $a1 (i64.load (i32.add (local.get $sp) (i32.const 16))))
  (local.set $a2 (i64.load (i32.add (local.get $sp) (i32.const  8))))
  (local.set $a3 (i64.load          (local.get $sp)))

  (local.set $sp (i32.sub (local.get $sp) (i32.const 32)))

  (i64.store (local.get $sp)
    (if (result i64)
      (i32.and 
          (i32.and 
            (i32.and 
              (i64.lt_u (local.get $a3) (i64.const 32))
              (i64.eqz (local.get $a2))) 
            (i64.eqz (local.get $a1)))
          (i64.eqz (local.get $a0)))
      (i64.load8_u (i32.sub (i32.const 31)(i32.wrap/i64 (local.get $a3))))
      (i64.const 0)))

  ;; zero out the rest of the stack
  (i64.store (i32.add (local.get $sp) (i32.const 24)) (i64.const 0))
  (i64.store (i32.add (local.get $sp) (i32.const 16)) (i64.const 0))
  (i64.store (i32.add (local.get $sp) (i32.const 8))  (i64.const 0))
)
