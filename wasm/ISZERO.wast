(func $ISZERO
  (local $a0 i64)
  (local $a1 i64)
  (local $a2 i64)
  (local $a3 i64)

  ;; load args from the stack
  (local.set $a0 (i64.load (i32.add (global.get $sp) (i32.const 24))))
  (local.set $a1 (i64.load (i32.add (global.get $sp) (i32.const 16))))
  (local.set $a2 (i64.load (i32.add (global.get $sp) (i32.const 8))))
  (local.set $a3 (i64.load (global.get $sp)))

  (i64.store (global.get $sp)
    (i64.extend_u/i32
      (call $iszero_256 (local.get $a0) (local.get $a1) (local.get $a2) (local.get $a3))
    )
  )

  ;; zero out the rest of memory
  (i64.store (i32.add (global.get $sp) (i32.const 8)) (i64.const 0))
  (i64.store (i32.add (global.get $sp) (i32.const 16)) (i64.const 0))
  (i64.store (i32.add (global.get $sp) (i32.const 24)) (i64.const 0))
)
