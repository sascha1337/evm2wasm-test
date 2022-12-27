;;
;; memcpy from ewasm-libc/ewasm-cleanup
;;
(func $memcpy
  (param $dst i32)
  (param $src i32)
  (param $length i32)
  (result i32)

  (local $i i32)

  (local.set $i (i32.const 0))

  (block $done
    (loop $loop
      (if (i32.ge_u (local.get $i) (local.get $length))
        (br $done)
      )

      (i32.store8 (i32.add (local.get $dst) (local.get $i)) (i32.load8_u (i32.add (local.get $src) (local.get $i))))

      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br $loop)
    )
  )

  (return (local.get $dst))
)
