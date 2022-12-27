(func $callback_160
  (param $result i32)

  (drop (call $bswap_m160 (global.get $sp)))
  (call $main)
)
