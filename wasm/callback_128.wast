(func $callback_128
  (param $result i32)

  (drop (call $bswap_m128 (global.get $sp)))
  (call $main)
)
