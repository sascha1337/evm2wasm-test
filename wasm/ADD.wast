(func $ADD
  (local $sp i32)

  (local $a i64)
  (local $c i64)
  (local $d i64)
  (local $carry i64)

  (local.set $sp (global.get $sp))
  
  ;; d c b a
  ;; pop the stack 
  (local.set $a (i64.load (i32.add (local.get $sp) (i32.const 24))))
  (local.set $c (i64.load (i32.add (local.get $sp) (i32.const 8))))
  (local.set $d (i64.load (local.get $sp)))
  ;; decement the stack pointer
  (local.set $sp (i32.sub (local.get $sp) (i32.const 8)))

  ;; d 
  (local.set $carry (i64.add (local.get $d) (i64.load (i32.sub (local.get $sp) (i32.const 24)))))
  ;; save d  to mem
  (i64.store (i32.sub (local.get $sp) (i32.const 24)) (local.get $carry))
  ;; check  for overflow
  (local.set $carry (i64.extend_u/i32 (i64.lt_u (local.get $carry) (local.get $d))))

  ;; c use $d as reg
  (local.set $d     (i64.add (i64.load (i32.sub (local.get $sp) (i32.const 16))) (local.get $carry)))
  (local.set $carry (i64.extend_u/i32 (i64.lt_u (local.get $d) (local.get $carry))))
  (local.set $d     (i64.add (local.get $c) (local.get $d)))
  ;; store the result
  (i64.store (i32.sub (local.get $sp) (i32.const 16)) (local.get $d))
  ;; check overflow
  (local.set $carry (i64.or (i64.extend_u/i32  (i64.lt_u (local.get $d) (local.get $c))) (local.get $carry)))

  ;; b
  ;; add carry
  (local.set $d     (i64.add (i64.load (i32.sub (local.get $sp) (i32.const 8))) (local.get $carry)))
  (local.set $carry (i64.extend_u/i32 (i64.lt_u (local.get $d) (local.get $carry))))

  ;; use reg c
  (local.set $c (i64.load (i32.add (local.get $sp) (i32.const 24))))
  (local.set $d (i64.add (local.get $c) (local.get $d)))
  (i64.store (i32.sub (local.get $sp) (i32.const 8)) (local.get $d))
  ;; a
  (i64.store (local.get $sp) 
             (i64.add        ;; add a 
               (local.get $a)
               (i64.add
                 (i64.load (local.get $sp))  ;; load the operand
                 (i64.or  ;; carry 
                   (i64.extend_u/i32 (i64.lt_u (local.get $d) (local.get $c))) 
                   (local.get $carry)))))
)
