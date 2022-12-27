(func $memusegas
  (param $offset i32)
  (param $length i32)

  (local $cost i64)
  ;; the number of new words being allocated
  (local $newWordCount i64)

  (if (i32.eqz (local.get $length))
    (then (return))
  )

  ;; const newMemoryWordCount = Math.ceil[[offset + length] / 32]
  (local.set $newWordCount 
    (i64.div_u (i64.add (i64.const 31) (i64.add (i64.extend_u/i32 (local.get $offset)) (i64.extend_u/i32 (local.get $length))))
               (i64.const 32)))

  ;;if [runState.highestMem >= highestMem]  return
  (if (i64.le_u (local.get $newWordCount) (global.get $wordCount))
    (then (return))
  )

  ;; words * 3 + words ^2 / 512
  (local.set $cost
     (i64.add
       (i64.mul (local.get $newWordCount) (i64.const 3))
       (i64.div_u
         (i64.mul (local.get $newWordCount)
                  (local.get $newWordCount))
         (i64.const 512))))

  (call $useGas  (i64.sub (local.get $cost) (global.get $prevMemCost)))
  (global.set $prevMemCost (local.get $cost))
  (global.set $wordCount (local.get $newWordCount))

  ;; grow actual memory
  ;; the first 31704 bytes are guaranteed to be available
  ;; adjust for 32 bytes  - the maximal size of MSTORE write
  ;; TODO it should be current_memory * page_size
  (local.set $offset (i32.add (local.get $length) (i32.add (local.get $offset) (global.get $memstart))))
  (if (i32.gt_u (local.get $offset) (i32.mul (i32.const 65536) (current_memory)))
    (then
      (drop (grow_memory
        (i32.div_u (i32.add (i32.const 65535) (i32.sub (local.get $offset) (current_memory))) (i32.const 65536))))
    )
  )
)
