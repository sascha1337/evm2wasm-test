(func $gte_320
  (param $a0 i64)
  (param $a1 i64)
  (param $a2 i64)
  (param $a3 i64)
  (param $a4 i64)

  (param $b0 i64)
  (param $b1 i64)
  (param $b2 i64)
  (param $b3 i64)
  (param $b4 i64)

  (result i32)

  ;; a0 > b0 || [a0 == b0 && [a1 > b1 || [a1 == b1 && [a2 > b2 || [a2 == b2 && a3 >= b3 ]]]]
  (i32.or  (i64.gt_u (local.get $a0) (local.get $b0)) ;; a0 > b0
  (i32.and (i64.eq   (local.get $a0) (local.get $b0))
  (i32.or  (i64.gt_u (local.get $a1) (local.get $b1)) ;; a1 > b1
  (i32.and (i64.eq   (local.get $a1) (local.get $b1)) ;; a1 == b1
  (i32.or  (i64.gt_u (local.get $a2) (local.get $b2)) ;; a2 > b2
  (i32.and (i64.eq   (local.get $a2) (local.get $b2))
  (i32.or  (i64.gt_u (local.get $a3) (local.get $b3)) ;; a2 > b2
  (i32.and (i64.eq   (local.get $a3) (local.get $b3))
           (i64.ge_u (local.get $a4) (local.get $b4))))))))))
)
