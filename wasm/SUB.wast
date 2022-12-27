(func $SUB
  (local $sp i32)

  (local $a i64)
  (local $b i64)
  (local $c i64)
  (local $d i64)

  (local $a1 i64)
  (local $b1 i64)
  (local $c1 i64)
  (local $d1 i64)

  (local $carry i64)
  (local $temp i64)

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

  ;; a * 64^3 + b*64^2 + c*64 + d 
  ;; d
  (local.set $carry (i64.extend_u/i32 (i64.lt_u (local.get $d) (local.get $d1))))
  (local.set $d (i64.sub (local.get $d) (local.get $d1)))

  ;; c
  (local.set $temp (i64.sub (local.get $c) (local.get $carry)))
  (local.set $carry (i64.extend_u/i32 (i64.gt_u (local.get $temp) (local.get $c))))
  (local.set $c (i64.sub (local.get $temp) (local.get $c1)))
  (local.set $carry (i64.or (i64.extend_u/i32 (i64.gt_u (local.get $c) (local.get $temp))) (local.get $carry)))

  ;; b
  (local.set $temp (i64.sub (local.get $b) (local.get $carry)))
  (local.set $carry (i64.extend_u/i32 (i64.gt_u (local.get $temp) (local.get $b))))
  (local.set $b (i64.sub (local.get $temp) (local.get $b1)))

  ;; a
  (local.set $a (i64.sub (i64.sub (local.get $a) (i64.or (i64.extend_u/i32 (i64.gt_u (local.get $b) (local.get $temp))) (local.get $carry))) (local.get $a1)))

  (i64.store (i32.add (local.get $sp) (i32.const 24)) (local.get $a))
  (i64.store (i32.add (local.get $sp) (i32.const 16)) (local.get $b))
  (i64.store (i32.add (local.get $sp) (i32.const  8)) (local.get $c))
  (i64.store          (local.get $sp)                 (local.get $d))
)
