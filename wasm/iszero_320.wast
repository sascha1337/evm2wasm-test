(func $iszero_320
  (param i64)
  (param i64)
  (param i64)
  (param i64)
  (param i64)
  (result i32)

  (i64.eqz (i64.or (i64.or (i64.or (i64.or (local.get 0) (local.get 1)) (local.get 2)) (local.get 3)) (local.get 4)))
)
