(func $DIV
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
  (local $temp  i64)
  (local $temp2  i64)

  (local.set $sp (global.get $sp))
  (local.set $maskd (i64.const 1))

  ;; load args from the stack
  (local.set $a (i64.load (i32.add (local.get $sp) (i32.const 24))))
  (local.set $b (i64.load (i32.add (local.get $sp) (i32.const 16))))
  (local.set $c (i64.load (i32.add (local.get $sp) (i32.const 8))))
  (local.set $d (i64.load (local.get $sp)))

  (local.set $sp (i32.sub (local.get $sp) (i32.const 32)))

  (local.set $a1 (i64.load (i32.add (local.get $sp) (i32.const 24))))
  (local.set $b1 (i64.load (i32.add (local.get $sp) (i32.const 16))))
  (local.set $c1 (i64.load (i32.add (local.get $sp) (i32.const 8))))
  (local.set $d1 (i64.load (local.get $sp)))

  (block $main
    ;; check div by 0
    (if (call $iszero_256 (local.get $a1) (local.get $b1) (local.get $c1) (local.get $d1))
      (br $main)
    )

    ;; align bits
    (block $done
      (loop $loop
        ;; align bits;
        (if 
          ;; check to make sure we are not overflowing
          (i32.or (i64.eqz (i64.clz (local.get $a1)))
          ;;  divisor < dividend
          (call $gte_256 (local.get $a1) (local.get $b1) (local.get $c1) (local.get $d1) (local.get $a) (local.get $b) (local.get $c) (local.get $d)))
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

            ;; result = result + mask
            (local.set $dq   (i64.add (local.get $maskd) (local.get $dq)))
            (local.set $temp (i64.extend_u/i32 (i64.lt_u (local.get $dq) (local.get $maskd))))
            (local.set $cq   (i64.add (local.get $cq) (local.get $temp)))
            (local.set $temp (i64.extend_u/i32 (i64.lt_u (local.get $cq) (local.get $temp))))
            (local.set $cq   (i64.add (local.get $maskc) (local.get $cq)))
            (local.set $temp (i64.or (i64.extend_u/i32  (i64.lt_u (local.get $cq) (local.get $maskc))) (local.get $temp)))
            (local.set $bq   (i64.add (local.get $bq) (local.get $temp)))
            (local.set $temp (i64.extend_u/i32 (i64.lt_u (local.get $bq) (local.get $temp))))
            (local.set $bq   (i64.add (local.get $maskb) (local.get $bq)))
            (local.set $aq   (i64.add (local.get $maska) (i64.add (local.get $aq) (i64.or (i64.extend_u/i32 (i64.lt_u (local.get $bq) (local.get $maskb))) (local.get $temp)))))
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
  );; end of main

  (i64.store (i32.add (local.get $sp) (i32.const 24)) (local.get $aq))
  (i64.store (i32.add (local.get $sp) (i32.const 16)) (local.get $bq))
  (i64.store (i32.add (local.get $sp) (i32.const 8))  (local.get $cq))
  (i64.store (local.get $sp) (local.get $dq))
)
