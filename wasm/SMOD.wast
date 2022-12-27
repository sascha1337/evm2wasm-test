(func $SMOD
  (local $sp i32)
  ;; dividend
  (local $a i64)
  (local $b i64)
  (local $c i64)
  (local $d i64)

  ;; divisor
  (local $a1 i64)
  (local $b1 i64)
  (local $c1 i64)
  (local $d1 i64)

  ;; quotient
  (local $aq i64)
  (local $bq i64)
  (local $cq i64)
  (local $dq i64)

  ;; mask
  (local $maska i64)
  (local $maskb i64)
  (local $maskc i64)
  (local $maskd i64)
  (local $carry i32)
  (local $sign i32)
  (local $temp  i64)
  (local $temp2  i64)

  ;; load args from the stack
  (local.set $a (i64.load (i32.add (global.get $sp) (i32.const 24))))
  (local.set $b (i64.load (i32.add (global.get $sp) (i32.const 16))))
  (local.set $c (i64.load (i32.add (global.get $sp) (i32.const  8))))
  (local.set $d (i64.load          (global.get $sp)))
  ;; decement the stack pointer
  (local.set $sp (i32.sub (global.get $sp) (i32.const 32)))

  (local.set $a1 (i64.load (i32.add (local.get $sp) (i32.const 24))))
  (local.set $b1 (i64.load (i32.add (local.get $sp) (i32.const 16))))
  (local.set $c1 (i64.load (i32.add (local.get $sp) (i32.const  8))))
  (local.set $d1 (i64.load          (local.get $sp)))

  (local.set $maskd (i64.const 1))
  (local.set $sign (i32.wrap/i64 (i64.shr_u (local.get $d) (i64.const 63))))

  ;; convert to unsigned value
  (if (i64.eqz (i64.clz (local.get $a)))
    (then
      (local.set $a (i64.xor (local.get $a) (i64.const -1)))
      (local.set $b (i64.xor (local.get $b) (i64.const -1)))
      (local.set $c (i64.xor (local.get $c) (i64.const -1)))
      (local.set $d (i64.xor (local.get $d) (i64.const -1)))

      ;; a = a + 1
      (local.set $d (i64.add (local.get $d) (i64.const 1)))
      (local.set $carry (i64.eqz (local.get $d)))
      (local.set $c (i64.add (local.get $c) (i64.extend_u/i32 (local.get $carry))))
      (local.set $carry (i32.and (i64.eqz (local.get $c)) (local.get $carry)))
      (local.set $b (i64.add (local.get $b) (i64.extend_u/i32 (local.get $carry))))
      (local.set $carry (i32.and (i64.eqz (local.get $b)) (local.get $carry)))
      (local.set $a (i64.add (local.get $a) (i64.extend_u/i32 (local.get $carry))))
    )
  )

  (if (i64.eqz (i64.clz (local.get $a1)))
    (then
      (local.set $a1 (i64.xor (local.get $a1) (i64.const -1)))
      (local.set $b1 (i64.xor (local.get $b1) (i64.const -1)))
      (local.set $c1 (i64.xor (local.get $c1) (i64.const -1)))
      (local.set $d1 (i64.xor (local.get $d1) (i64.const -1)))

      (local.set $d1 (i64.add (local.get $d1) (i64.const 1)))
      (local.set $carry (i64.eqz (local.get $d1)))
      (local.set $c1 (i64.add (local.get $c1) (i64.extend_u/i32 (local.get $carry))))
      (local.set $carry (i32.and (i64.eqz (local.get $c1)) (local.get $carry)))
      (local.set $b1 (i64.add (local.get $b1) (i64.extend_u/i32 (local.get $carry))))
      (local.set $carry (i32.and (i64.eqz (local.get $b1)) (local.get $carry)))
      (local.set $a1 (i64.add (local.get $a1) (i64.extend_u/i32 (local.get $carry))))
    )
  )
  
  (block $main
    ;; check div by 0
    (if (call $iszero_256 (local.get $a1) (local.get $b1) (local.get $c1) (local.get $d1))
      (then
        (local.set $a (i64.const 0))
        (local.set $b (i64.const 0))
        (local.set $c (i64.const 0))
        (local.set $d (i64.const 0))
        (br $main)
      )
    )

    ;; align bits
    (block $done
      (loop $loop
        ;; align bits;
        (if (i32.or (i64.eqz (i64.clz (local.get $a1))) (call $gte_256 (local.get $a1) (local.get $b1) (local.get $c1) (local.get $d1) (local.get $a) (local.get $b) (local.get $c) (local.get $d)))
          (br $done)
        )

        ;; divisor = divisor << 1
        (local.set $a1 (i64.add (i64.shl (local.get $a1) (i64.const 1)) (i64.shr_u (local.get $b1) (i64.const 63))))
        (local.set $b1 (i64.add (i64.shl (local.get $b1) (i64.const 1)) (i64.shr_u (local.get $c1) (i64.const 63))))
        (local.set $c1 (i64.add (i64.shl (local.get $c1) (i64.const 1)) (i64.shr_u (local.get $d1) (i64.const 63))))
        (local.set $d1 (i64.shl (local.get $d1) (i64.const 1)))

        ;; mask = mask << 1
        (local.set $maska (i64.add (i64.shl (local.get $maska) (i64.const 1)) (i64.shr_u (local.get $maskb) (i64.const 63))))
        (local.set $maskb (i64.add (i64.shl (local.get $maskb) (i64.const 1)) (i64.shr_u (local.get $maskc) (i64.const 63))))
        (local.set $maskc (i64.add (i64.shl (local.get $maskc) (i64.const 1)) (i64.shr_u (local.get $maskd) (i64.const 63))))
        (local.set $maskd (i64.shl (local.get $maskd) (i64.const 1)))

        (br $loop)
      )
    )

    (block $done
      (loop $loop
        ;; loop while mask != 0
        (if (call $iszero_256 (local.get $maska) (local.get $maskb) (local.get $maskc) (local.get $maskd))
          (br $done)
        )
        ;; if dividend >= divisor
        (if (call $gte_256 (local.get $a) (local.get $b) (local.get $c) (local.get $d) (local.get $a1) (local.get $b1) (local.get $c1) (local.get $d1))
          (then
            ;; dividend = dividend - divisor
            (local.set $carry (i64.lt_u (local.get $d) (local.get $d1)))
            (local.set $d     (i64.sub  (local.get $d) (local.get $d1)))
            (local.set $temp  (i64.sub  (local.get $c) (i64.extend_u/i32 (local.get $carry))))
            (local.set $carry (i64.gt_u (local.get $temp) (local.get $c)))
            (local.set $c     (i64.sub  (local.get $temp) (local.get $c1)))
            (local.set $carry (i32.or   (i64.gt_u (local.get $c) (local.get $temp)) (local.get $carry)))
            (local.set $temp  (i64.sub  (local.get $b) (i64.extend_u/i32 (local.get $carry))))
            (local.set $carry (i64.gt_u (local.get $temp) (local.get $b)))
            (local.set $b     (i64.sub  (local.get $temp) (local.get $b1)))
            (local.set $carry (i32.or   (i64.gt_u (local.get $b) (local.get $temp)) (local.get $carry)))
            (local.set $a     (i64.sub  (i64.sub (local.get $a) (i64.extend_u/i32 (local.get $carry))) (local.get $a1)))
          )
        )
        ;; divisor = divisor >> 1
        (local.set $d1 (i64.add (i64.shr_u (local.get $d1) (i64.const 1)) (i64.shl (local.get $c1) (i64.const 63))))
        (local.set $c1 (i64.add (i64.shr_u (local.get $c1) (i64.const 1)) (i64.shl (local.get $b1) (i64.const 63))))
        (local.set $b1 (i64.add (i64.shr_u (local.get $b1) (i64.const 1)) (i64.shl (local.get $a1) (i64.const 63))))
        (local.set $a1 (i64.shr_u (local.get $a1) (i64.const 1)))

        ;; mask = mask >> 1
        (local.set $maskd (i64.add (i64.shr_u (local.get $maskd) (i64.const 1)) (i64.shl (local.get $maskc) (i64.const 63))))
        (local.set $maskc (i64.add (i64.shr_u (local.get $maskc) (i64.const 1)) (i64.shl (local.get $maskb) (i64.const 63))))
        (local.set $maskb (i64.add (i64.shr_u (local.get $maskb) (i64.const 1)) (i64.shl (local.get $maska) (i64.const 63))))
        (local.set $maska (i64.shr_u (local.get $maska) (i64.const 1)))
        (br $loop)
      )
    )
  )

  ;; convert to signed
  (if (local.get $sign)
    (then
      (local.set $a (i64.xor (local.get $a) (i64.const -1)))
      (local.set $b (i64.xor (local.get $b) (i64.const -1)))
      (local.set $c (i64.xor (local.get $c) (i64.const -1)))
      (local.set $d (i64.xor (local.get $d) (i64.const -1)))

      (local.set $d (i64.add (local.get $d) (i64.const 1)))
      (local.set $c (i64.add (local.get $c) (i64.extend_u/i32 (i64.eqz (local.get $d)))))
      (local.set $b (i64.add (local.get $b) (i64.extend_u/i32 (i64.eqz (local.get $c)))))
      (local.set $a (i64.add (local.get $a) (i64.extend_u/i32 (i64.eqz (local.get $b)))))
    )
  )

  ;; save the stack
  (i64.store (i32.add (local.get $sp) (i32.const 24)) (local.get $a))
  (i64.store (i32.add (local.get $sp) (i32.const 16)) (local.get $b))
  (i64.store (i32.add (local.get $sp) (i32.const  8)) (local.get $c))
  (i64.store          (local.get $sp)                 (local.get $d))
) ;; end for SMOD
