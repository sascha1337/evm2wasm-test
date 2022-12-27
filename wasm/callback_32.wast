(func $callback_32
  (param $result i32)

  (i64.store (global.get $sp) (i64.extend_u/i32 (local.get $result)))
  ;; zero out mem
  (i64.store (i32.add (global.get $sp) (i32.const 24)) (i64.const 0))
  (i64.store (i32.add (global.get $sp) (i32.const 16)) (i64.const 0))
  (i64.store (i32.add (global.get $sp) (i32.const 8)) (i64.const 0))

  (call $main)
)
