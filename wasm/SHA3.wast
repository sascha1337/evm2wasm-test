(func $SHA3
  (local $dataOffset i32)
  (local $dataOffset0 i64)
  (local $dataOffset1 i64)
  (local $dataOffset2 i64)
  (local $dataOffset3 i64)

  (local $length i32)
  (local $length0 i64)
  (local $length1 i64)
  (local $length2 i64)
  (local $length3 i64)

  (local $contextOffset i32)
  (local $outputOffset i32)

  (local.set $length0 (i64.load (i32.sub (global.get $sp) (i32.const 32))))
  (local.set $length1 (i64.load (i32.sub (global.get $sp) (i32.const 24))))
  (local.set $length2 (i64.load (i32.sub (global.get $sp) (i32.const 16))))
  (local.set $length3 (i64.load (i32.sub (global.get $sp) (i32.const 8))))

  (local.set $dataOffset0 (i64.load (i32.add (global.get $sp) (i32.const 0))))
  (local.set $dataOffset1 (i64.load (i32.add (global.get $sp) (i32.const 8))))
  (local.set $dataOffset2 (i64.load (i32.add (global.get $sp) (i32.const 16))))
  (local.set $dataOffset3 (i64.load (i32.add (global.get $sp) (i32.const 24))))

  (local.set $length 
             (call $check_overflow (local.get $length0)
                                   (local.get $length1)
                                   (local.get $length2)
                                   (local.get $length3)))
  (local.set $dataOffset 
             (call $check_overflow (local.get $dataOffset0)
                                   (local.get $dataOffset1)
                                   (local.get $dataOffset2)
                                   (local.get $dataOffset3)))

  ;; charge copy fee ceil(words/32) * 6 
  (call $useGas (i64.extend_u/i32 (i32.mul (i32.div_u (i32.add (local.get $length) (i32.const 31)) (i32.const 32)) (i32.const 6))))
  (call $memusegas (local.get $dataOffset) (local.get $length))

  (local.set $dataOffset (i32.add (global.get $memstart) (local.get $dataOffset)))

  (local.set $contextOffset (i32.const 32808))
  (local.set $outputOffset (i32.sub (global.get $sp) (i32.const 32)))

  (call $keccak (local.get $contextOffset) (local.get $dataOffset) (local.get $length) (local.get $outputOffset))

  (drop (call $bswap_m256 (local.get $outputOffset)))
)
