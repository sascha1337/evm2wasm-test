(func $SWAP
  (param $a0 i32)
  (local $sp_ref i32)

  (local $topa i64)
  (local $topb i64)
  (local $topc i64)
  (local $topd i64)
  
  (local.set $sp_ref (i32.sub (i32.add  (global.get $sp) (i32.const 24)) (i32.mul (i32.add (local.get $a0) (i32.const 1)) (i32.const 32))))

  (local.set $topa (i64.load (i32.add (global.get $sp) (i32.const 24))))
  (local.set $topb (i64.load (i32.add (global.get $sp) (i32.const 16))))
  (local.set $topc (i64.load (i32.add (global.get $sp) (i32.const  8))))
  (local.set $topd (i64.load          (global.get $sp)))
  
  ;; replace the top element
  (i64.store (i32.add (global.get $sp) (i32.const 24)) (i64.load (local.get $sp_ref)))
  (i64.store (i32.add (global.get $sp) (i32.const 16)) (i64.load (i32.sub (local.get $sp_ref) (i32.const 8))))
  (i64.store (i32.add (global.get $sp) (i32.const  8)) (i64.load (i32.sub (local.get $sp_ref) (i32.const 16))))
  (i64.store          (global.get $sp)                 (i64.load (i32.sub (local.get $sp_ref) (i32.const 24))))

  ;; store the old top element
  (i64.store (local.get $sp_ref)                          (local.get $topa))
  (i64.store (i32.sub (local.get $sp_ref) (i32.const 8))  (local.get $topb))
  (i64.store (i32.sub (local.get $sp_ref) (i32.const 16)) (local.get $topc))
  (i64.store (i32.sub (local.get $sp_ref) (i32.const 24)) (local.get $topd))
)
