(func $MSIZE
  (local $sp i32)

  ;; there's no input item for us to overwrite
  (local.set $sp (i32.add (global.get $sp) (i32.const 32)))

  (i64.store (i32.add (local.get $sp) (i32.const 0)) 
             (i64.mul (global.get $wordCount) (i64.const 32)))
  (i64.store (i32.add (local.get $sp) (i32.const 8)) (i64.const 0))
  (i64.store (i32.add (local.get $sp) (i32.const 16)) (i64.const 0))
  (i64.store (i32.add (local.get $sp) (i32.const 24)) (i64.const 0))
)
