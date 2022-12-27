(func $bswap_m128
  (param $sp i32)
  (result i32)
  (local $temp i64)

  (local.set $temp (call $bswap_i64 (i64.load (local.get $sp))))
  (i64.store (local.get $sp) (call $bswap_i64 (i64.load (i32.add (local.get $sp) (i32.const 8)))))
  (i64.store (i32.add (local.get $sp) (i32.const 8)) (local.get $temp))
  (local.get $sp)
)
