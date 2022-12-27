;; stack:
;;  0: A
;; -1: B
;; -2: MOD
(func $ADDMOD
  (local $sp i32)

  (local $a i64)
  (local $b i64)
  (local $c i64)
  (local $d i64)

  (local $a1 i64)
  (local $b1 i64)
  (local $c1 i64)
  (local $d1 i64)

  (local $moda i64)
  (local $modb i64)
  (local $modc i64)
  (local $modd i64)

  (local $carry i64)

  (local.set $sp (global.get $sp))

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

  (local.set $sp (i32.sub (local.get $sp) (i32.const 32)))

  (local.set $moda (i64.load (i32.add (local.get $sp) (i32.const 24))))
  (local.set $modb (i64.load (i32.add (local.get $sp) (i32.const 16))))
  (local.set $modc (i64.load (i32.add (local.get $sp) (i32.const 8))))
  (local.set $modd (i64.load (local.get $sp)))

  ;; a * 64^3 + b*64^2 + c*64 + d 
  ;; d 
  (local.set $d     (i64.add (local.get $d1) (local.get $d)))
  (local.set $carry (i64.extend_u/i32 (i64.lt_u (local.get $d) (local.get $d1))))
  ;; c
  (local.set $c     (i64.add (local.get $c) (local.get $carry)))
  (local.set $carry (i64.extend_u/i32 (i64.lt_u (local.get $c) (local.get $carry))))
  (local.set $c     (i64.add (local.get $c1) (local.get $c)))
  (local.set $carry (i64.or (i64.extend_u/i32  (i64.lt_u (local.get $c) (local.get $c1))) (local.get $carry)))
  ;; b
  (local.set $b     (i64.add (local.get $b) (local.get $carry)))
  (local.set $carry (i64.extend_u/i32 (i64.lt_u (local.get $b) (local.get $carry))))
  (local.set $b     (i64.add (local.get $b1) (local.get $b)))
  (local.set $carry (i64.or (i64.extend_u/i32  (i64.lt_u (local.get $b) (local.get $b1))) (local.get $carry)))
  ;; a
  (local.set $a     (i64.add (local.get $a) (local.get $carry)))
  (local.set $carry (i64.extend_u/i32 (i64.lt_u (local.get $a) (local.get $carry))))
  (local.set $a     (i64.add (local.get $a1) (local.get $a)))
  (local.set $carry (i64.or (i64.extend_u/i32  (i64.lt_u (local.get $a) (local.get $a1))) (local.get $carry)))

  (call $mod_320
        (local.get $carry) (local.get $a)    (local.get $b)    (local.get $c)    (local.get $d)
        (i64.const 0)      (local.get $moda) (local.get $modb) (local.get $modc) (local.get $modd) (local.get $sp))
)
