;;
;; memcpy from ewasm-libc/ewasm-cleanup
;;
(func $memset
  (param $ptr i32)
  (param $value i32)
  (param $length i32)
  (result i32)
  (local $i i32)

  (local.set $i (i32.const 0))

  (block $done
    (loop $loop
      (if (i32.ge_u (local.get $i) (local.get $length))
        (br $done)
      )

      (i32.store8 (i32.add (local.get $ptr) (local.get $i)) (local.get $value))

      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br $loop)
    )
  )
  (local.get $ptr)
)
