(func $LOG
  (param $number i32)

  (local $offset i32)
  (local $offset0 i64)
  (local $offset1 i64)
  (local $offset2 i64)
  (local $offset3 i64)

  (local $length i32)
  (local $length0 i64)
  (local $length1 i64)
  (local $length2 i64)
  (local $length3 i64)

  (local.set $offset0 (i64.load          (global.get $sp)))
  (local.set $offset1 (i64.load (i32.add (global.get $sp) (i32.const  8))))
  (local.set $offset2 (i64.load (i32.add (global.get $sp) (i32.const 16))))
  (local.set $offset3 (i64.load (i32.add (global.get $sp) (i32.const 24))))

  (local.set $length0 (i64.load (i32.sub (global.get $sp) (i32.const 32))))
  (local.set $length1 (i64.load (i32.sub (global.get $sp) (i32.const 24))))
  (local.set $length2 (i64.load (i32.sub (global.get $sp) (i32.const 16))))
  (local.set $length3 (i64.load (i32.sub (global.get $sp) (i32.const  8))))

  (local.set $offset 
             (call $check_overflow (local.get $offset0)
                                   (local.get $offset1)
                                   (local.get $offset2)
                                   (local.get $offset3)))

  (local.set $length
             (call $check_overflow (local.get $length0)
                                   (local.get $length1)
                                   (local.get $length2)
                                   (local.get $length3)))

  (call $memusegas (local.get $offset) (local.get $length))

  (call $log 
             (local.get $offset)
             (local.get $length)
             (local.get $number)
             (i32.sub (global.get $sp) (i32.const  64))
             (i32.sub (global.get $sp) (i32.const  96))
             (i32.sub (global.get $sp) (i32.const 128))
             (i32.sub (global.get $sp) (i32.const 160)))
)
