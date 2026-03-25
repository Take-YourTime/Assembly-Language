	stmfd   sp!, {r0, r1, fp, lr}   @ 命令列呼叫 → r0 = argc, r1 = argv
	
	adds r1,r2,r3
	mov r1, #1
L1:	add r1, r1, #1
	cmple r2, #100
	ble L2
L2:
	ldr r3, [r1, #10]
	str r5, [r2], #6
	push {r0, r1, lr}
	pop {r0, r1, lr}
