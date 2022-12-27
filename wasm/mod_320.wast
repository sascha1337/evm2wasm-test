(func $mod_320
  ;; dividend
  (param $a i64)
  (param $b i64)
  (param $c i64)
  (param $d i64)
  (param $e i64)

  ;; divisor
  (param $a1 i64)
  (param $b1 i64)
  (param $c1 i64)
  (param $d1 i64)
  (param $e1 i64)

  ;; stack pointer
  (param $sp i32)

  ;; quotient
  (local $aq i64)
  (local $bq i64)
  (local $cq i64)
  (local $dq i64)
  (local $eq i64)

  ;; mask
  (local $maska i64)
  (local $maskb i64)
  (local $maskc i64)
  (local $maskd i64)
  (local $maske i64)

  (local $carry i32)
  (local $temp i64)

  (local.set $maske (i64.const 1))
  (block $main
    ;; check div by 0
    (if (call $iszero_320 (local.get $a1) (local.get $b1) (local.get $c1) (local.get $d1) (local.get $e1)) 
      (then
        (local.set $a (i64.const 0))
        (local.set $b (i64.const 0))
        (local.set $c (i64.const 0))
        (local.set $d (i64.const 0))
        (local.set $e (i64.const 0))
        (br $main)
      )
    )

    (block $done
      ;; align bits
      (loop $loop
        ;; align bits;
        (if (i32.or (i64.eqz (i64.clz (local.get $a1))) (call $gte_320
                                                            (local.get $a1) (local.get $b1) (local.get $c1) (local.get $d1) (local.get $e1)
                                                            (local.get $a) (local.get $b) (local.get $c) (local.get $d) (local.get $e)))
          (br $done)
        )

        ;; divisor = divisor << 1
        (local.set $a1 (i64.add (i64.shl (local.get $a1) (i64.const 1)) (i64.shr_u (local.get $b1) (i64.const 63))))
        (local.set $b1 (i64.add (i64.shl (local.get $b1) (i64.const 1)) (i64.shr_u (local.get $c1) (i64.const 63))))
        (local.set $c1 (i64.add (i64.shl (local.get $c1) (i64.const 1)) (i64.shr_u (local.get $d1) (i64.const 63))))
        (local.set $d1 (i64.add (i64.shl (local.get $d1) (i64.const 1)) (i64.shr_u (local.get $e1) (i64.const 63))))
        (local.set $e1 (i64.shl (local.get $e1) (i64.const 1)))

        ;; mask = mask << 1
        (local.set $maska (i64.add (i64.shl (local.get $maska) (i64.const 1)) (i64.shr_u (local.get $maskb) (i64.const 63))))
        (local.set $maskb (i64.add (i64.shl (local.get $maskb) (i64.const 1)) (i64.shr_u (local.get $maskc) (i64.const 63))))
        (local.set $maskc (i64.add (i64.shl (local.get $maskc) (i64.const 1)) (i64.shr_u (local.get $maskd) (i64.const 63))))
        (local.set $maskd (i64.add (i64.shl (local.get $maskd) (i64.const 1)) (i64.shr_u (local.get $maske) (i64.const 63))))
        (local.set $maske (i64.shl (local.get $maske) (i64.const 1)))
        (br $loop)
      )
    )

    (block $done
      (loop $loop
        ;; loop while mask != 0
        (if (call $iszero_320 (local.get $maska) (local.get $maskb) (local.get $maskc) (local.get $maskd) (local.get $maske))
          (br $done)
        )
        ;; if dividend >= divisor
        (if (call $gte_320 (local.get $a) (local.get $b) (local.get $c) (local.get $d) (local.get $e) (local.get $a1) (local.get $b1) (local.get $c1) (local.get $d1) (local.get $e1))
          (then
            ;; dividend = dividend - divisor
            (local.set $carry (i64.lt_u (local.get $e) (local.get $e1)))
            (local.set $e     (i64.sub  (local.get $e) (local.get $e1)))

            (local.set $temp  (i64.sub  (local.get $d) (i64.extend_u/i32 (local.get $carry))))
            (local.set $carry (i64.gt_u (local.get $temp) (local.get $d)))
            (local.set $d     (i64.sub  (local.get $temp) (local.get $d1)))
            (local.set $carry (i32.or   (i64.gt_u (local.get $d) (local.get $temp)) (local.get $carry)))

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
        (local.set $e1 (i64.add (i64.shr_u (local.get $e1) (i64.const 1)) (i64.shl (local.get $d1) (i64.const 63))))
        (local.set $d1 (i64.add (i64.shr_u (local.get $d1) (i64.const 1)) (i64.shl (local.get $c1) (i64.const 63))))
        (local.set $c1 (i64.add (i64.shr_u (local.get $c1) (i64.const 1)) (i64.shl (local.get $b1) (i64.const 63))))
        (local.set $b1 (i64.add (i64.shr_u (local.get $b1) (i64.const 1)) (i64.shl (local.get $a1) (i64.const 63))))
        (local.set $a1 (i64.shr_u (local.get $a1) (i64.const 1)))

        ;; mask = mask >> 1
        (local.set $maske (i64.add (i64.shr_u (local.get $maske) (i64.const 1)) (i64.shl (local.get $maskd) (i64.const 63))))
        (local.set $maskd (i64.add (i64.shr_u (local.get $maskd) (i64.const 1)) (i64.shl (local.get $maskc) (i64.const 63))))
        (local.set $maskc (i64.add (i64.shr_u (local.get $maskc) (i64.const 1)) (i64.shl (local.get $maskb) (i64.const 63))))
        (local.set $maskb (i64.add (i64.shr_u (local.get $maskb) (i64.const 1)) (i64.shl (local.get $maska) (i64.const 63))))
        (local.set $maska (i64.shr_u (local.get $maska) (i64.const 1)))
        (br $loop)
      )
    )
  );; end of main
  (i64.store (i32.add (local.get $sp) (i32.const 24)) (local.get $b))
  (i64.store (i32.add (local.get $sp) (i32.const 16)) (local.get $c))
  (i64.store (i32.add (local.get $sp) (i32.const 8))  (local.get $d))
  (i64.store (local.get $sp)                          (local.get $e))
)
