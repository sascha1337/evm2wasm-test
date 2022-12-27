(func $PUSH
  (param $a0 i64)
  (param $a1 i64)
  (param $a2 i64)
  (param $a3 i64)
  (local $sp i32)

  ;; increament stack pointer
  (local.set $sp (i32.add (global.get $sp) (i32.const 32)))

  (i64.store (local.get $sp) (local.get $a3))
  (i64.store (i32.add (local.get $sp) (i32.const 8)) (local.get $a2))
  (i64.store (i32.add (local.get $sp) (i32.const 16)) (local.get $a1))
  (i64.store (i32.add (local.get $sp) (i32.const 24)) (local.get $a0))
)
