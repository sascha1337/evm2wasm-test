(func $check_overflow
  (param $a i64)
  (param $b i64)
  (param $c i64)
  (param $d i64)
  (result i32)

  (local $MAX_INT i32)
  (local.set $MAX_INT (i32.const -1))

  (if
    (i32.and 
      (i32.and 
        (i64.eqz  (local.get $d))
        (i64.eqz  (local.get $c)))
      (i32.and 
        (i64.eqz  (local.get $b))
        (i64.lt_u (local.get $a) (i64.extend_u/i32 (local.get $MAX_INT)))))
     (return (i32.wrap/i64 (local.get $a))))

     (return (local.get $MAX_INT))
)
