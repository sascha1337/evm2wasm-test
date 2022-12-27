(func $SIGNEXTEND
  (local $sp i32)

  (local $a0 i64)
  (local $a1 i64)
  (local $a2 i64)
  (local $a3 i64)

  (local $b0 i64)
  (local $b1 i64)
  (local $b2 i64)
  (local $b3 i64)
  (local $sign i64)
  (local $t i32)
  (local $end i32)

  (local.set $a0 (i64.load (i32.add (global.get $sp) (i32.const 24))))
  (local.set $a1 (i64.load (i32.add (global.get $sp) (i32.const 16))))
  (local.set $a2 (i64.load (i32.add (global.get $sp) (i32.const  8))))
  (local.set $a3 (i64.load          (global.get $sp)))

  (local.set $end (global.get $sp))
  (local.set $sp (i32.sub (global.get $sp) (i32.const 32)))

  (if (i32.and 
        (i32.and 
          (i32.and 
            (i64.lt_u (local.get $a3) (i64.const 32))
            (i64.eqz (local.get $a2))) 
          (i64.eqz (local.get $a1)))
        (i64.eqz (local.get $a0)))
    (then
      (local.set $t (i32.add (i32.wrap/i64 (local.get $a3)) (local.get $sp))) 
      (local.set $sign (i64.shr_s (i64.load8_s (local.get $t)) (i64.const 8)))
      (local.set $t (i32.add (local.get $t) (i32.const 1)))
      (block $done
        (loop $loop
          (if (i32.lt_u (local.get $end) (local.get $t))
            (br $done)
          )
          (i64.store (local.get $t) (local.get $sign))
          (local.set $t (i32.add (local.get $t) (i32.const 8)))
          (br $loop)
        )
      )
    )
  )
)

