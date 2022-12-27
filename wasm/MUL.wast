(func $MUL
  (call $mul_256
        (i64.load (i32.add (global.get $sp) (i32.const 24)))
        (i64.load (i32.add (global.get $sp) (i32.const 16)))
        (i64.load (i32.add (global.get $sp) (i32.const  8)))
        (i64.load          (global.get $sp))
        (i64.load (i32.sub (global.get $sp) (i32.const  8)))
        (i64.load (i32.sub (global.get $sp) (i32.const 16)))
        (i64.load (i32.sub (global.get $sp) (i32.const 24)))
        (i64.load (i32.sub (global.get $sp) (i32.const 32)))
        (i32.sub (global.get $sp) (i32.const 8))
  )
)
