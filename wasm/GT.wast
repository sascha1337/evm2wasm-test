(func $GT
  (local $sp i32)

  (local $a0 i64)
  (local $a1 i64)
  (local $a2 i64)
  (local $a3 i64)
  (local $b0 i64)
  (local $b1 i64)
  (local $b2 i64)
  (local $b3 i64)

  (local.set $sp (global.get $sp))

  ;; load args from the stack
  (local.set $a0 (i64.load (i32.add (local.get $sp) (i32.const 24))))
  (local.set $a1 (i64.load (i32.add (local.get $sp) (i32.const 16))))
  (local.set $a2 (i64.load (i32.add (local.get $sp) (i32.const 8))))
  (local.set $a3 (i64.load (local.get $sp)))

  (local.set $sp (i32.sub (local.get $sp) (i32.const 32)))

  (local.set $b0 (i64.load (i32.add (local.get $sp) (i32.const 24))))
  (local.set $b1 (i64.load (i32.add (local.get $sp) (i32.const 16))))
  (local.set $b2 (i64.load (i32.add (local.get $sp) (i32.const 8))))
  (local.set $b3 (i64.load (local.get $sp)))

  (i64.store (local.get $sp) (i64.extend_u/i32 
    (i32.or (i64.gt_u (local.get $a0) (local.get $b0)) ;; a0 > b0
    (i32.and (i64.eq   (local.get $a0) (local.get $b0)) ;; a0 == a1
    (i32.or  (i64.gt_u (local.get $a1) (local.get $b1)) ;; a1 > b1
    (i32.and (i64.eq   (local.get $a1) (local.get $b1)) ;; a1 == b1
    (i32.or  (i64.gt_u (local.get $a2) (local.get $b2)) ;; a2 > b2
    (i32.and (i64.eq   (local.get $a2) (local.get $b2)) ;; a2 == b2
             (i64.gt_u (local.get $a3) (local.get $b3)))))))))) ;; a3 > b3

  ;; zero  out the rest of the stack item
  (i64.store (i32.add (local.get $sp) (i32.const  8)) (i64.const 0))
  (i64.store (i32.add (local.get $sp) (i32.const 16)) (i64.const 0))
  (i64.store (i32.add (local.get $sp) (i32.const 24)) (i64.const 0))
)
