(func $PC
  (param $pc i32)
  (local $sp i32)

  ;; add one to the stack
  (local.set $sp (i32.add (global.get $sp) (i32.const 32)))
  (i64.store (local.get $sp) (i64.extend_u/i32 (local.get $pc)))

  ;; zero out rest of stack
  (i64.store (i32.add (local.get $sp) (i32.const 8)) (i64.const 0))
  (i64.store (i32.add (local.get $sp) (i32.const 16)) (i64.const 0))
  (i64.store (i32.add (local.get $sp) (i32.const 24)) (i64.const 0))
)
