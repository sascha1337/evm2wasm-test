(func $EQ
  (local $sp i32)

  (local.set $sp (i32.sub (global.get $sp) (i32.const 32)))
  (i64.store (local.get $sp)
    (i64.extend_u/i32
      (i32.and (i64.eq   (i64.load (i32.add (local.get $sp) (i32.const 56))) (i64.load (i32.add (local.get $sp) (i32.const 24))))
      (i32.and (i64.eq   (i64.load (i32.add (local.get $sp) (i32.const 48))) (i64.load (i32.add (local.get $sp) (i32.const 16))))
      (i32.and (i64.eq   (i64.load (i32.add (local.get $sp) (i32.const 40))) (i64.load (i32.add (local.get $sp) (i32.const  8))))
               (i64.eq   (i64.load (i32.add (local.get $sp) (i32.const 32))) (i64.load          (local.get $sp))))))))

  (i64.store (i32.add (local.get $sp) (i32.const 24)) (i64.const 0))
  (i64.store (i32.add (local.get $sp) (i32.const 16)) (i64.const 0))
  (i64.store (i32.add (local.get $sp) (i32.const  8)) (i64.const 0))
)
