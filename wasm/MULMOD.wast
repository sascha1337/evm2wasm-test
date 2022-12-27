(func $MULMOD
  (local $sp i32)

  (local $a i64)
  (local $c i64)
  (local $e i64)
  (local $g i64)
  (local $i i64)
  (local $k i64)
  (local $m i64)
  (local $o i64)
  (local $b i64)
  (local $d i64)
  (local $f i64)
  (local $h i64)
  (local $j i64)
  (local $l i64)
  (local $n i64)
  (local $p i64)
  (local $temp7 i64)
  (local $temp6 i64)
  (local $temp5 i64)
  (local $temp4 i64)
  (local $temp3 i64)
  (local $temp2 i64)
  (local $temp1 i64)
  (local $temp0 i64)
  (local $rowCarry i64)

  (local $moda i64)
  (local $modb i64)
  (local $modc i64)
  (local $modd i64)

  ;; pop two items of the stack
  (local.set $a (i64.load (i32.add (global.get $sp) (i32.const 24))))
  (local.set $c (i64.load (i32.add (global.get $sp) (i32.const 16))))
  (local.set $e (i64.load (i32.add (global.get $sp) (i32.const  8))))
  (local.set $g (i64.load          (global.get $sp)))
  (local.set $i (i64.load (i32.sub (global.get $sp) (i32.const  8))))
  (local.set $k (i64.load (i32.sub (global.get $sp) (i32.const 16))))
  (local.set $m (i64.load (i32.sub (global.get $sp) (i32.const 24))))
  (local.set $o (i64.load (i32.sub (global.get $sp) (i32.const 32))))

  (local.set $sp (i32.sub (global.get $sp) (i32.const 64)))

  ;; MUL
  ;;  a b c d e f g h
  ;;* i j k l m n o p
  ;;----------------

  ;; split the ops
  (local.set $b (i64.and (local.get $a) (i64.const 4294967295)))
  (local.set $a (i64.shr_u (local.get $a) (i64.const 32))) 

  (local.set $d (i64.and (local.get $c) (i64.const 4294967295)))
  (local.set $c (i64.shr_u (local.get $c) (i64.const 32))) 

  (local.set $f (i64.and (local.get $e) (i64.const 4294967295)))
  (local.set $e (i64.shr_u (local.get $e) (i64.const 32)))

  (local.set $h (i64.and (local.get $g) (i64.const 4294967295)))
  (local.set $g (i64.shr_u (local.get $g) (i64.const 32)))

  (local.set $j (i64.and (local.get $i) (i64.const 4294967295)))
  (local.set $i (i64.shr_u (local.get $i) (i64.const 32))) 

  (local.set $l (i64.and (local.get $k) (i64.const 4294967295)))
  (local.set $k (i64.shr_u (local.get $k) (i64.const 32))) 

  (local.set $n (i64.and (local.get $m) (i64.const 4294967295)))
  (local.set $m (i64.shr_u (local.get $m) (i64.const 32)))

  (local.set $p (i64.and (local.get $o) (i64.const 4294967295)))
  (local.set $o (i64.shr_u (local.get $o) (i64.const 32)))

   ;; first row multiplication 
  ;; p * h
  (local.set $temp0 (i64.mul (local.get $p) (local.get $h)))
  ;; p * g + carry
  (local.set $temp1 (i64.add (i64.mul (local.get $p) (local.get $g)) (i64.shr_u (local.get $temp0) (i64.const 32))))
  ;; p * f + carry
  (local.set $temp2 (i64.add (i64.mul (local.get $p) (local.get $f)) (i64.shr_u (local.get $temp1) (i64.const 32))))
  ;; p * e + carry
  (local.set $temp3 (i64.add (i64.mul (local.get $p) (local.get $e)) (i64.shr_u (local.get $temp2) (i64.const 32))))
  ;; p * d + carry
  (local.set $temp4 (i64.add (i64.mul (local.get $p) (local.get $d)) (i64.shr_u (local.get $temp3) (i64.const 32))))
  ;; p * c + carry
  (local.set $temp5 (i64.add (i64.mul (local.get $p) (local.get $c)) (i64.shr_u (local.get $temp4) (i64.const 32))))
  ;; p * b + carry
  (local.set $temp6 (i64.add (i64.mul (local.get $p) (local.get $b)) (i64.shr_u (local.get $temp5) (i64.const 32))))
  ;; p * a + carry
  (local.set $temp7 (i64.add (i64.mul (local.get $p) (local.get $a)) (i64.shr_u (local.get $temp6) (i64.const 32))))
  (local.set $rowCarry (i64.shr_u (local.get $temp7) (i64.const 32)))

  ;; second row
  ;; o * h + $temp1 
  (local.set $temp1 (i64.add (i64.mul (local.get $o) (local.get $h)) (i64.and (local.get $temp1) (i64.const 4294967295))))
  ;; o * g + $temp2 + carry
  (local.set $temp2 (i64.add (i64.add (i64.mul (local.get $o) (local.get $g)) (i64.and (local.get $temp2) (i64.const 4294967295))) (i64.shr_u (local.get $temp1) (i64.const 32))))
  ;; o * f + $temp3 + carry
  (local.set $temp3 (i64.add (i64.add (i64.mul (local.get $o) (local.get $f)) (i64.and (local.get $temp3) (i64.const 4294967295))) (i64.shr_u (local.get $temp2) (i64.const 32))))
  ;; o * e + $temp4 + carry
  (local.set $temp4 (i64.add (i64.add (i64.mul (local.get $o) (local.get $e)) (i64.and (local.get $temp4) (i64.const 4294967295))) (i64.shr_u (local.get $temp3) (i64.const 32))))
  ;; o * d + $temp5 + carry
  (local.set $temp5 (i64.add (i64.add (i64.mul (local.get $o) (local.get $d)) (i64.and (local.get $temp5) (i64.const 4294967295))) (i64.shr_u (local.get $temp4) (i64.const 32))))
  ;; o * c + $temp6 + carry
  (local.set $temp6 (i64.add (i64.add (i64.mul (local.get $o) (local.get $c)) (i64.and (local.get $temp6) (i64.const 4294967295))) (i64.shr_u (local.get $temp5) (i64.const 32))))
  ;; o * b + $temp7 + carry
  (local.set $temp7 (i64.add (i64.add (i64.mul (local.get $o) (local.get $b)) (i64.and (local.get $temp7) (i64.const 4294967295))) (i64.shr_u (local.get $temp6) (i64.const 32))))
  ;; o * a + carry + rowCarry
  (local.set $p (i64.add (i64.add (i64.mul (local.get $o) (local.get $a)) (i64.shr_u (local.get $temp7) (i64.const 32))) (local.get $rowCarry)))
  (local.set $rowCarry (i64.shr_u (local.get $p) (i64.const 32)))

  ;; third row - n
  ;; n * h + $temp2 
  (local.set $temp2 (i64.add (i64.mul (local.get $n) (local.get $h)) (i64.and (local.get $temp2) (i64.const 4294967295))))
  ;; n * g + $temp3  carry
  (local.set $temp3 (i64.add (i64.add (i64.mul (local.get $n) (local.get $g)) (i64.and (local.get $temp3) (i64.const 4294967295))) (i64.shr_u (local.get $temp2) (i64.const 32))))
  ;; n * f + $temp4) + carry
  (local.set $temp4 (i64.add (i64.add (i64.mul (local.get $n) (local.get $f)) (i64.and (local.get $temp4) (i64.const 4294967295))) (i64.shr_u (local.get $temp3) (i64.const 32))))
  ;; n * e + $temp5 + carry
  (local.set $temp5 (i64.add (i64.add (i64.mul (local.get $n) (local.get $e)) (i64.and (local.get $temp5) (i64.const 4294967295))) (i64.shr_u (local.get $temp4) (i64.const 32))))
  ;; n * d + $temp6 + carry
  (local.set $temp6 (i64.add (i64.add (i64.mul (local.get $n) (local.get $d)) (i64.and (local.get $temp6) (i64.const 4294967295))) (i64.shr_u (local.get $temp5) (i64.const 32))))
  ;; n * c + $temp7 + carry
  (local.set $temp7 (i64.add (i64.add (i64.mul (local.get $n) (local.get $c)) (i64.and (local.get $temp7) (i64.const 4294967295))) (i64.shr_u (local.get $temp6) (i64.const 32))))
  ;; n * b + $p + carry
  (local.set $p     (i64.add (i64.add (i64.mul (local.get $n) (local.get $b)) (i64.and (local.get $p)     (i64.const 4294967295))) (i64.shr_u (local.get $temp7) (i64.const 32))))
  ;; n * a + carry
  (local.set $o (i64.add (i64.add (i64.mul (local.get $n) (local.get $a)) (i64.shr_u (local.get $p) (i64.const 32))) (local.get $rowCarry)))
  (local.set $rowCarry (i64.shr_u (local.get $o) (i64.const 32)))

  ;; forth row 
  ;; m * h + $temp3
  (local.set $temp3 (i64.add (i64.mul (local.get $m) (local.get $h)) (i64.and (local.get $temp3) (i64.const 4294967295))))
  ;; m * g + $temp4 + carry
  (local.set $temp4 (i64.add (i64.add (i64.mul (local.get $m) (local.get $g)) (i64.and (local.get $temp4) (i64.const 4294967295))) (i64.shr_u (local.get $temp3) (i64.const 32))))
  ;; m * f + $temp5 + carry
  (local.set $temp5 (i64.add (i64.add (i64.mul (local.get $m) (local.get $f)) (i64.and (local.get $temp5) (i64.const 4294967295))) (i64.shr_u (local.get $temp4) (i64.const 32))))
  ;; m * e + $temp6 + carry
  (local.set $temp6 (i64.add (i64.add (i64.mul (local.get $m) (local.get $e)) (i64.and (local.get $temp6) (i64.const 4294967295))) (i64.shr_u (local.get $temp5) (i64.const 32))))
  ;; m * d + $temp7 + carry
  (local.set $temp7 (i64.add (i64.add (i64.mul (local.get $m) (local.get $d)) (i64.and (local.get $temp7) (i64.const 4294967295))) (i64.shr_u (local.get $temp6) (i64.const 32))))
  ;; m * c + $p + carry
  (local.set $p     (i64.add (i64.add (i64.mul (local.get $m) (local.get $c)) (i64.and (local.get $p)     (i64.const 4294967295))) (i64.shr_u (local.get $temp7) (i64.const 32))))
  ;; m * b + $o + carry
  (local.set $o     (i64.add (i64.add (i64.mul (local.get $m) (local.get $b)) (i64.and (local.get $o)     (i64.const 4294967295))) (i64.shr_u (local.get $p)     (i64.const 32))))
  ;; m * a + carry + rowCarry
  (local.set $n     (i64.add (i64.add (i64.mul (local.get $m) (local.get $a)) (i64.shr_u (local.get $o) (i64.const 32))) (local.get $rowCarry)))
  (local.set $rowCarry (i64.shr_u (local.get $n) (i64.const 32)))

  ;; fith row
  ;; l * h + $temp4
  (local.set $temp4 (i64.add (i64.mul (local.get $l) (local.get $h)) (i64.and (local.get $temp4) (i64.const 4294967295))))
  ;; l * g + $temp5 + carry
  (local.set $temp5 (i64.add (i64.add (i64.mul (local.get $l) (local.get $g)) (i64.and (local.get $temp5) (i64.const 4294967295))) (i64.shr_u (local.get $temp4) (i64.const 32))))
  ;; l * f + $temp6 + carry
  (local.set $temp6 (i64.add (i64.add (i64.mul (local.get $l) (local.get $f)) (i64.and (local.get $temp6) (i64.const 4294967295))) (i64.shr_u (local.get $temp5) (i64.const 32))))
  ;; l * e + $temp7 + carry
  (local.set $temp7 (i64.add (i64.add (i64.mul (local.get $l) (local.get $e)) (i64.and (local.get $temp7) (i64.const 4294967295))) (i64.shr_u (local.get $temp6) (i64.const 32))))
  ;; l * d + $p + carry
  (local.set $p     (i64.add (i64.add (i64.mul (local.get $l) (local.get $d)) (i64.and (local.get $p)     (i64.const 4294967295))) (i64.shr_u (local.get $temp7) (i64.const 32))))
  ;; l * c + $o + carry
  (local.set $o     (i64.add (i64.add (i64.mul (local.get $l) (local.get $c)) (i64.and (local.get $o)     (i64.const 4294967295))) (i64.shr_u (local.get $p)     (i64.const 32))))
  ;; l * b + $n + carry
  (local.set $n     (i64.add (i64.add (i64.mul (local.get $l) (local.get $b)) (i64.and (local.get $n)     (i64.const 4294967295))) (i64.shr_u (local.get $o)     (i64.const 32))))
  ;; l * a + carry + rowCarry
  (local.set $m     (i64.add (i64.add (i64.mul (local.get $l) (local.get $a)) (i64.shr_u (local.get $n) (i64.const 32))) (local.get $rowCarry)))
  (local.set $rowCarry (i64.shr_u (local.get $m) (i64.const 32)))

  ;; sixth row 
  ;; k * h + $temp5
  (local.set $temp5 (i64.add (i64.mul (local.get $k) (local.get $h)) (i64.and (local.get $temp5) (i64.const 4294967295))))
  ;; k * g + $temp6 + carry
  (local.set $temp6 (i64.add (i64.add (i64.mul (local.get $k) (local.get $g)) (i64.and (local.get $temp6) (i64.const 4294967295))) (i64.shr_u (local.get $temp5) (i64.const 32))))
  ;; k * f + $temp7 + carry
  (local.set $temp7 (i64.add (i64.add (i64.mul (local.get $k) (local.get $f)) (i64.and (local.get $temp7) (i64.const 4294967295))) (i64.shr_u (local.get $temp6) (i64.const 32))))
  ;; k * e + $p + carry
  (local.set $p     (i64.add (i64.add (i64.mul (local.get $k) (local.get $e)) (i64.and (local.get $p)     (i64.const 4294967295))) (i64.shr_u (local.get $temp7) (i64.const 32))))
  ;; k * d + $o + carry
  (local.set $o     (i64.add (i64.add (i64.mul (local.get $k) (local.get $d)) (i64.and (local.get $o)     (i64.const 4294967295))) (i64.shr_u (local.get $p)     (i64.const 32))))
  ;; k * c + $n + carry
  (local.set $n     (i64.add (i64.add (i64.mul (local.get $k) (local.get $c)) (i64.and (local.get $n)     (i64.const 4294967295))) (i64.shr_u (local.get $o)     (i64.const 32))))
  ;; k * b + $m + carry
  (local.set $m     (i64.add (i64.add (i64.mul (local.get $k) (local.get $b)) (i64.and (local.get $m)     (i64.const 4294967295))) (i64.shr_u (local.get $n)     (i64.const 32))))
  ;; k * a + carry
  (local.set $l     (i64.add (i64.add (i64.mul (local.get $k) (local.get $a)) (i64.shr_u (local.get $m) (i64.const 32))) (local.get $rowCarry)))
  (local.set $rowCarry (i64.shr_u (local.get $l) (i64.const 32)))

  ;; seventh row
  ;; j * h + $temp6
  (local.set $temp6 (i64.add (i64.mul (local.get $j) (local.get $h)) (i64.and (local.get $temp6) (i64.const 4294967295))))
  ;; j * g + $temp7 + carry
  (local.set $temp7 (i64.add (i64.add (i64.mul (local.get $j) (local.get $g)) (i64.and (local.get $temp7) (i64.const 4294967295))) (i64.shr_u (local.get $temp6) (i64.const 32))))
  ;; j * f + $p +carry
  (local.set $p     (i64.add (i64.add (i64.mul (local.get $j) (local.get $f)) (i64.and (local.get $p)     (i64.const 4294967295))) (i64.shr_u (local.get $temp7) (i64.const 32))))
  ;; j * e + $o + carry
  (local.set $o     (i64.add (i64.add (i64.mul (local.get $j) (local.get $e)) (i64.and (local.get $o)     (i64.const 4294967295))) (i64.shr_u (local.get $p)     (i64.const 32))))
  ;; j * d + $n + carry
  (local.set $n     (i64.add (i64.add (i64.mul (local.get $j) (local.get $d)) (i64.and (local.get $n)     (i64.const 4294967295))) (i64.shr_u (local.get $o)     (i64.const 32))))
  ;; j * c + $m + carry
  (local.set $m     (i64.add (i64.add (i64.mul (local.get $j) (local.get $c)) (i64.and (local.get $m)     (i64.const 4294967295))) (i64.shr_u (local.get $n)     (i64.const 32))))
  ;; j * b + $l + carry
  (local.set $l     (i64.add (i64.add (i64.mul (local.get $j) (local.get $b)) (i64.and (local.get $l)     (i64.const 4294967295))) (i64.shr_u (local.get $m)     (i64.const 32))))
  ;; j * a + carry
  (local.set $k     (i64.add (i64.add (i64.mul (local.get $j) (local.get $a)) (i64.shr_u (local.get $l) (i64.const 32))) (local.get $rowCarry)))
  (local.set $rowCarry (i64.shr_u (local.get $k) (i64.const 32)))

  ;; eigth row
  ;; i * h + $temp7 
  (local.set $temp7 (i64.add (i64.mul (local.get $i) (local.get $h)) (i64.and (local.get $temp7) (i64.const 4294967295))))
  ;; i * g + $p 
  (local.set $p     (i64.add (i64.add (i64.mul (local.get $i) (local.get $g)) (i64.and (local.get $p)     (i64.const 4294967295))) (i64.shr_u (local.get $temp7) (i64.const 32))))
  ;; i * f + $o + carry
  (local.set $o     (i64.add (i64.add (i64.mul (local.get $i) (local.get $f)) (i64.and (local.get $o)     (i64.const 4294967295))) (i64.shr_u (local.get $p)     (i64.const 32))))
  ;; i * e + $n + carry
  (local.set $n     (i64.add (i64.add (i64.mul (local.get $i) (local.get $e)) (i64.and (local.get $n)     (i64.const 4294967295))) (i64.shr_u (local.get $o)     (i64.const 32))))
  ;; i * d + $m + carry
  (local.set $m     (i64.add (i64.add (i64.mul (local.get $i) (local.get $d)) (i64.and (local.get $m)     (i64.const 4294967295))) (i64.shr_u (local.get $n)     (i64.const 32))))
  ;; i * c + $l + carry
  (local.set $l     (i64.add (i64.add (i64.mul (local.get $i) (local.get $c)) (i64.and (local.get $l)     (i64.const 4294967295))) (i64.shr_u (local.get $m)     (i64.const 32))))
  ;; i * b + $k + carry
  (local.set $k     (i64.add (i64.add (i64.mul (local.get $i) (local.get $b)) (i64.and (local.get $k)     (i64.const 4294967295))) (i64.shr_u (local.get $l)     (i64.const 32))))
  ;; i * a + carry
  (local.set $j     (i64.add (i64.add (i64.mul (local.get $i) (local.get $a)) (i64.shr_u (local.get $k) (i64.const 32))) (local.get $rowCarry)))

  ;; combine terms
  (local.set $a (local.get $j))
  (local.set $b (i64.or (i64.shl (local.get $k)     (i64.const 32)) (i64.and (local.get $l)     (i64.const 4294967295))))
  (local.set $c (i64.or (i64.shl (local.get $m)     (i64.const 32)) (i64.and (local.get $n)     (i64.const 4294967295))))
  (local.set $d (i64.or (i64.shl (local.get $o)     (i64.const 32)) (i64.and (local.get $p)     (i64.const 4294967295))))
  (local.set $e (i64.or (i64.shl (local.get $temp7) (i64.const 32)) (i64.and (local.get $temp6) (i64.const 4294967295))))
  (local.set $f (i64.or (i64.shl (local.get $temp5) (i64.const 32)) (i64.and (local.get $temp4) (i64.const 4294967295))))
  (local.set $g (i64.or (i64.shl (local.get $temp3) (i64.const 32)) (i64.and (local.get $temp2) (i64.const 4294967295))))
  (local.set $h (i64.or (i64.shl (local.get $temp1) (i64.const 32)) (i64.and (local.get $temp0) (i64.const 4294967295))))

  ;; pop the MOD argmunet off the stack
  (local.set $moda (i64.load (i32.add (local.get $sp) (i32.const 24))))
  (local.set $modb (i64.load (i32.add (local.get $sp) (i32.const 16))))
  (local.set $modc (i64.load (i32.add (local.get $sp) (i32.const  8))))
  (local.set $modd (i64.load          (local.get $sp)))

  (call $mod_512
         (local.get $a) (local.get $b) (local.get $c) (local.get $d) (local.get $e) (local.get $f) (local.get $g) (local.get $h) 
         (i64.const 0)  (i64.const 0) (i64.const 0)  (i64.const 0)  (local.get $moda) (local.get $modb) (local.get $modc) (local.get $modd) (i32.add (local.get $sp) (i32.const 24))
  )
)
