(func $mul_256
  ;;  a b c d e f g h
  ;;* i j k l m n o p
  ;;----------------
  (param $a i64)
  (param $c i64)
  (param $e i64)
  (param $g i64)

  (param $i i64)
  (param $k i64)
  (param $m i64)
  (param $o i64)

  (param $sp i32)

  (local $b i64)
  (local $d i64)
  (local $f i64)
  (local $h i64)
  (local $j i64)
  (local $l i64)
  (local $n i64)
  (local $p i64)
  (local $temp6 i64)
  (local $temp5 i64)
  (local $temp4 i64)
  (local $temp3 i64)
  (local $temp2 i64)
  (local $temp1 i64)
  (local $temp0 i64)

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
  (local.set $temp5  (i64.add (i64.mul (local.get $p) (local.get $c)) (i64.shr_u (local.get $temp4) (i64.const 32))))
  ;; p * b + carry
  (local.set $temp6  (i64.add (i64.mul (local.get $p) (local.get $b)) (i64.shr_u (local.get $temp5) (i64.const 32))))
  ;; p * a + carry
  (local.set $a  (i64.add (i64.mul (local.get $p) (local.get $a)) (i64.shr_u (local.get $temp6) (i64.const 32))))
  ;; second row
  ;; o * h + $temp1 "pg"
  (local.set $temp1 (i64.add (i64.mul (local.get $o) (local.get $h)) (i64.and (local.get $temp1) (i64.const 4294967295))))
  ;; o * g + $temp2 "pf" + carry
  (local.set $temp2 (i64.add (i64.add (i64.mul (local.get $o) (local.get $g)) (i64.and (local.get $temp2) (i64.const 4294967295))) (i64.shr_u (local.get $temp1) (i64.const 32))))
  ;; o * f + $temp3 "pe" + carry
  (local.set $temp3 (i64.add (i64.add (i64.mul (local.get $o) (local.get $f)) (i64.and (local.get $temp3) (i64.const 4294967295))) (i64.shr_u (local.get $temp2) (i64.const 32))))
  ;; o * e + $temp4  + carry
  (local.set $temp4 (i64.add (i64.add (i64.mul (local.get $o) (local.get $e)) (i64.and (local.get $temp4) (i64.const 4294967295))) (i64.shr_u (local.get $temp3) (i64.const 32))))
  ;; o * d + $temp5  + carry
  (local.set $temp5 (i64.add (i64.add (i64.mul (local.get $o) (local.get $d)) (i64.and (local.get $temp5) (i64.const 4294967295))) (i64.shr_u (local.get $temp4) (i64.const 32))))
  ;; o * c + $temp6  + carry
  (local.set $temp6 (i64.add (i64.add (i64.mul (local.get $o) (local.get $c)) (i64.and (local.get $temp6) (i64.const 4294967295))) (i64.shr_u (local.get $temp5) (i64.const 32))))
  ;; o * b + $a  + carry
  (local.set $a (i64.add (i64.add (i64.mul (local.get $o) (local.get $b)) (i64.and (local.get $a) (i64.const 4294967295))) (i64.shr_u (local.get $temp6) (i64.const 32))))
  ;; third row - n
  ;; n * h + $temp2 
  (local.set $temp2 (i64.add (i64.mul (local.get $n) (local.get $h)) (i64.and (local.get $temp2) (i64.const 4294967295))))
  ;; n * g + $temp3 + carry
  (local.set $temp3 (i64.add (i64.add (i64.mul (local.get $n) (local.get $g)) (i64.and (local.get $temp3) (i64.const 4294967295))) (i64.shr_u (local.get $temp2) (i64.const 32))))
  ;; n * f + $temp4 + carry
  (local.set $temp4 (i64.add (i64.add (i64.mul (local.get $n) (local.get $f)) (i64.and (local.get $temp4) (i64.const 4294967295))) (i64.shr_u (local.get $temp3) (i64.const 32))))
  ;; n * e + $temp5  + carry
  (local.set $temp5 (i64.add (i64.add (i64.mul (local.get $n) (local.get $e)) (i64.and (local.get $temp5) (i64.const 4294967295))) (i64.shr_u (local.get $temp4) (i64.const 32))))
  ;; n * d + $temp6  + carry
  (local.set $temp6 (i64.add (i64.add (i64.mul (local.get $n) (local.get $d)) (i64.and (local.get $temp6) (i64.const 4294967295))) (i64.shr_u (local.get $temp5) (i64.const 32))))
  ;; n * c + $a  + carry
  (local.set $a (i64.add (i64.add (i64.mul (local.get $n) (local.get $c)) (i64.and (local.get $a) (i64.const 4294967295))) (i64.shr_u (local.get $temp6) (i64.const 32))))

  ;; forth row 
  ;; m * h + $temp3
  (local.set $temp3 (i64.add (i64.mul (local.get $m) (local.get $h)) (i64.and (local.get $temp3) (i64.const 4294967295))))
  ;; m * g + $temp4 + carry
  (local.set $temp4 (i64.add (i64.add (i64.mul (local.get $m) (local.get $g)) (i64.and (local.get $temp4) (i64.const 4294967295))) (i64.shr_u (local.get $temp3) (i64.const 32))))
  ;; m * f + $temp5 + carry
  (local.set $temp5 (i64.add (i64.add (i64.mul (local.get $m) (local.get $f)) (i64.and (local.get $temp5) (i64.const 4294967295))) (i64.shr_u (local.get $temp4) (i64.const 32))))
  ;; m * e + $temp6 + carry
  (local.set $temp6 (i64.add (i64.add (i64.mul (local.get $m) (local.get $e)) (i64.and (local.get $temp6) (i64.const 4294967295))) (i64.shr_u (local.get $temp5) (i64.const 32))))
  ;; m * d + $a + carry
  (local.set $a (i64.add (i64.add (i64.mul (local.get $m) (local.get $d)) (i64.and (local.get $a) (i64.const 4294967295))) (i64.shr_u (local.get $temp6) (i64.const 32))))

  ;; fith row
  ;; l * h + $temp4
  (local.set $temp4 (i64.add (i64.mul (local.get $l) (local.get $h)) (i64.and (local.get $temp4) (i64.const 4294967295))))
  ;; l * g + $temp5 + carry
  (local.set $temp5 (i64.add (i64.add (i64.mul (local.get $l) (local.get $g)) (i64.and (local.get $temp5) (i64.const 4294967295))) (i64.shr_u (local.get $temp4) (i64.const 32))))
  ;; l * f + $temp6 + carry
  (local.set $temp6 (i64.add (i64.add (i64.mul (local.get $l) (local.get $f)) (i64.and (local.get $temp6) (i64.const 4294967295))) (i64.shr_u (local.get $temp5) (i64.const 32))))
  ;; l * e + $a + carry
  (local.set $a (i64.add (i64.add (i64.mul (local.get $l) (local.get $e)) (i64.and (local.get $a) (i64.const 4294967295))) (i64.shr_u (local.get $temp6) (i64.const 32))))

  ;; sixth row 
  ;; k * h + $temp5
  (local.set $temp5 (i64.add (i64.mul (local.get $k) (local.get $h)) (i64.and (local.get $temp5) (i64.const 4294967295))))
  ;; k * g + $temp6 + carry
  (local.set $temp6 (i64.add (i64.add (i64.mul (local.get $k) (local.get $g)) (i64.and (local.get $temp6) (i64.const 4294967295))) (i64.shr_u (local.get $temp5) (i64.const 32))))
  ;; k * f + $a + carry
  (local.set $a (i64.add (i64.add (i64.mul (local.get $k) (local.get $f)) (i64.and (local.get $a) (i64.const 4294967295))) (i64.shr_u (local.get $temp6) (i64.const 32))))

  ;; seventh row
  ;; j * h + $temp6
  (local.set $temp6 (i64.add (i64.mul (local.get $j) (local.get $h)) (i64.and (local.get $temp6) (i64.const 4294967295))))
  ;; j * g + $a + carry

  ;; eigth row
  ;; i * h + $a
  (local.set $a (i64.add (i64.mul (local.get $i) (local.get $h)) (i64.and (i64.add (i64.add (i64.mul (local.get $j) (local.get $g)) (i64.and (local.get $a) (i64.const 4294967295))) (i64.shr_u (local.get $temp6) (i64.const 32))) (i64.const 4294967295))))

  ;; combine terms
  (local.set $a (i64.or (i64.shl (local.get $a) (i64.const 32)) (i64.and (local.get $temp6) (i64.const 4294967295))))
  (local.set $c (i64.or (i64.shl (local.get $temp5) (i64.const 32)) (i64.and (local.get $temp4) (i64.const 4294967295))))
  (local.set $e (i64.or (i64.shl (local.get $temp3) (i64.const 32)) (i64.and (local.get $temp2) (i64.const 4294967295))))
  (local.set $g (i64.or (i64.shl (local.get $temp1) (i64.const 32)) (i64.and (local.get $temp0) (i64.const 4294967295))))

  ;; save stack 
  (i64.store (local.get $sp) (local.get $a))
  (i64.store (i32.sub (local.get $sp) (i32.const 8)) (local.get $c))
  (i64.store (i32.sub (local.get $sp) (i32.const 16)) (local.get $e))
  (i64.store (i32.sub (local.get $sp) (i32.const 24)) (local.get $g))
)
