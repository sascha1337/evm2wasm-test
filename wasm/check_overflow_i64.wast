(func $check_overflow_i64
  (param $a i64)
  (param $b i64)
  (param $c i64)
  (param $d i64)
  (result i64)

  (if
    (i32.and 
      (i32.and 
        (i64.eqz  (local.get $d))
        (i64.eqz  (local.get $c)))
      (i64.eqz  (local.get $b)))
    (return (local.get $a)))

    (return (i64.const 0xffffffffffffffff))
)
