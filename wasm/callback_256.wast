(func $callback_256
  (param $result i32)

  (drop (call $bswap_m256 (global.get $sp)))
  (call $main)
)
