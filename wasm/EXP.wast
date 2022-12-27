(func $EXP
  (local $sp i32)

  ;; base
  (local $base0 i64)
  (local $base1 i64)
  (local $base2 i64)
  (local $base3 i64)

  ;; exp
  (local $exp0 i64)
  (local $exp1 i64)
  (local $exp2 i64)
  (local $exp3 i64)

  (local $r0 i64)
  (local $r1 i64)
  (local $r2 i64)
  (local $r3 i64)

  (local $gasCounter i32)
  (local.set $sp (global.get $sp))

  ;; load args from the stack
  (local.set $base0 (i64.load (i32.add (local.get $sp) (i32.const 24))))
  (local.set $base1 (i64.load (i32.add (local.get $sp) (i32.const 16))))
  (local.set $base2 (i64.load (i32.add (local.get $sp) (i32.const  8))))
  (local.set $base3 (i64.load          (local.get $sp)))

  (local.set $sp (i32.sub (local.get $sp) (i32.const 32)))

  (local.set $exp0 (i64.load (i32.add (local.get $sp) (i32.const 24))))
  (local.set $exp1 (i64.load (i32.add (local.get $sp) (i32.const 16))))
  (local.set $exp2 (i64.load (i32.add (local.get $sp) (i32.const  8))))
  (local.set $exp3 (i64.load          (local.get $sp)))

  ;; let result = new BN[1]
  (local.set $r3 (i64.const 1))

  (block $done
    (loop $loop
       ;; while [exp > 0] {
      (if (call $iszero_256 (local.get $exp0) (local.get $exp1) (local.get $exp2) (local.get $exp3))
        (br $done) 
      )

      ;; if[exp.modn[2] === 1]
      ;; is odd?
      (if (i64.eqz (i64.ctz (local.get $exp3)))

        ;; result = result.mul[base].mod[TWO_POW256]
        ;; r = r * a
        (then
          (call $mul_256 (local.get $r0) (local.get $r1) (local.get $r2) (local.get $r3) (local.get $base0) (local.get $base1) (local.get $base2) (local.get $base3) (i32.add (local.get $sp) (i32.const 24)))
          (local.set $r0 (i64.load (i32.add (local.get $sp) (i32.const 24))))
          (local.set $r1 (i64.load (i32.add (local.get $sp) (i32.const 16))))
          (local.set $r2 (i64.load (i32.add (local.get $sp) (i32.const  8))))
          (local.set $r3 (i64.load          (local.get $sp)))
        )
      )
      ;; exp = exp.shrn 1
      (local.set $exp3 (i64.add (i64.shr_u (local.get $exp3) (i64.const 1)) (i64.shl (local.get $exp2) (i64.const 63))))
      (local.set $exp2 (i64.add (i64.shr_u (local.get $exp2) (i64.const 1)) (i64.shl (local.get $exp1) (i64.const 63))))
      (local.set $exp1 (i64.add (i64.shr_u (local.get $exp1) (i64.const 1)) (i64.shl (local.get $exp0) (i64.const 63))))
      (local.set $exp0 (i64.shr_u (local.get $exp0) (i64.const 1)))

      ;; base = base.mulr[baser].modr[TWO_POW256]
      (call $mul_256 (local.get $base0) (local.get $base1) (local.get $base2) (local.get $base3) (local.get $base0) (local.get $base1) (local.get $base2) (local.get $base3) (i32.add (local.get $sp) (i32.const 24)))
      (local.set $base0 (i64.load (i32.add (local.get $sp) (i32.const 24))))
      (local.set $base1 (i64.load (i32.add (local.get $sp) (i32.const 16))))
      (local.set $base2 (i64.load (i32.add (local.get $sp) (i32.const  8))))
      (local.set $base3 (i64.load          (local.get $sp)))

      (local.set $gasCounter (i32.add (local.get $gasCounter) (i32.const 1)))
      (br $loop)
    )
  ) 

  ;; use gas
  ;; Log256[Exponent] * 10
  (call $useGas
    (i64.extend_u/i32
      (i32.mul
        (i32.const 10)
        (i32.div_u
          (i32.add (local.get $gasCounter) (i32.const 7))
          (i32.const 8)))))

  ;; decement the stack pointer
  (i64.store (i32.add (local.get $sp) (i32.const 24)) (local.get $r0))
  (i64.store (i32.add (local.get $sp) (i32.const 16)) (local.get $r1))
  (i64.store (i32.add (local.get $sp) (i32.const  8)) (local.get $r2))
  (i64.store          (local.get $sp)                 (local.get $r3))
)
