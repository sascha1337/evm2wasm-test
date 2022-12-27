(func $DUP
  (param $a0 i32)
  (local $sp i32)

  (local $sp_ref i32)
  
  (local.set $sp (i32.add (global.get $sp) (i32.const 32)))
  (local.set $sp_ref (i32.sub (i32.sub (local.get $sp) (i32.const 8)) (i32.mul (local.get $a0) (i32.const 32))))
  
  (i64.store (i32.add (local.get $sp) (i32.const 24)) (i64.load (local.get $sp_ref)))
  (i64.store (i32.add (local.get $sp) (i32.const 16)) (i64.load (i32.sub (local.get $sp_ref) (i32.const 8))))
  (i64.store (i32.add (local.get $sp) (i32.const  8)) (i64.load (i32.sub (local.get $sp_ref) (i32.const 16))))
  (i64.store          (local.get $sp)                 (i64.load (i32.sub (local.get $sp_ref) (i32.const 24))))
)
