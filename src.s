
	.gba

	.include ver
	NEW_FOLDER_SIZE equ 40

	oJoypad_Held equ 0x00
	JOYPAD_START equ 0x08

	.open INPUT_FILE, OUTPUT_FILE, 0x8000000

	.org COUNT_NUM_REMAINING_BATTLE_CHIPS_MOV_R3_30_ADDR
	mov r3, NEW_FOLDER_SIZE

	.org COUNT_NUM_REMAINING_BATTLE_CHIPS_MOV_R0_30_ADDR
	mov r0, NEW_FOLDER_SIZE

	.org SUB_802945A_MOV_R2_30_ADDR
	mov r2, NEW_FOLDER_SIZE

	.org SUB_802945A_CMP_R4_60_ADDR
	cmp r4, NEW_FOLDER_SIZE*2

	.org ENQUEUE_TRASH_CHUTE_CHIPS_CMP_R4_60_ADDR
	cmp r4, NEW_FOLDER_SIZE*2

	.org SUB_800A3E4_MOV_R2_60_ADDR
	// force folder 1
	//mov r2, NEW_FOLDER_SIZE*2
	nop
	mov r2, 0

	.org SUB_800A3E4_TAG1_STORE_ADDR
	b sub_800A3E4_Tag1Store_Hook
sub_800A3E4_Tag1Store_HookReturn:

	.org SUB_800A3E4_TAG2_STORE_ADDR
	b sub_800A3E4_Tag2Store_Hook
sub_800A3E4_Tag2Store_HookReturn:

	.org SUB_800A3E4_CMP_R2_60_ADDR
	cmp r2, NEW_FOLDER_SIZE * 2

	.org SUB_800A570_CMP_R4_30_ADDR
	cmp r4, NEW_FOLDER_SIZE

	.org SUB_800A570_TAG_WRITES_ADDR
	b sub_800A570_TagWrites_Hook

	.org SUB_800A570_DO_NOT_INSERT_TAG_ADDR
sub_800A570_TagWrites_HookReturn:

	.org SUB_800A570_HALFWORD_COUNT_ADDR
	mov r2, NEW_FOLDER_SIZE*2

	.org BATTLE_COPY_STRUCTS_DWORD_203CDF0_WRITE_ADDR
	nop

	.org BATTLE_COPY_STRUCTS_DWORD_203CDF4_WRITE_ADDR
	nop

	.org FOLDER_SHUFFLE_FUNCS_FREE_SPACE
sub_800A3E4_Tag1Store_Hook:
	push {r2}
	mov r2, NEW_FOLDER_SIZE * 2 - 4
	strh r0, [r1,r2]
	pop {r2}
	b sub_800A3E4_Tag1Store_HookReturn

sub_800A3E4_Tag2Store_Hook:
	push {r2}
	mov r2, NEW_FOLDER_SIZE * 2 - 2
	strh r0, [r1,r2]
	pop {r2}
	b sub_800A3E4_Tag2Store_HookReturn

sub_800A570_TagWrites_Hook:
	mov r2, NEW_FOLDER_SIZE * 2 - 4
	ldrh r3, [r0,r2]
	ldrh r4, [r0,r1]
	strh r4, [r0,r2]
	strh r3, [r0,r1]
	add r1, #2
	add r2, #2
	ldrh r3, [r0,r2]
	ldrh r4, [r0,r1]
	strh r4, [r0,r2]
	strh r3, [r0,r1]
	b sub_800A570_TagWrites_HookReturn

	.org SHUFFLE_FOLDER_SLICE_ADDR
ShuffleFolderSlice:
	push {r4-r6,lr}
	sub r4, r1, 1
	beq @@done
@@loop:
	push {r0}
	bl GetPositiveSignedRNG1
	add r1, r4, 1
	swi 6 // r1 = rand() % (r1 + 1)
	pop {r0}

	add r1, r1, r1
	add r3, r4, r4
	ldrh r5, [r0,r1]
	ldrh r6, [r0,r3]
	strh r6, [r0,r1]
	strh r5, [r0,r3]
	sub r4, 1
	bne @@loop
@@done:
	pop {r4-r6,pc}

//	.org CUST_MENU_A_JUMPTABLE_ADDR+4
//	.word CustMenuPressAFunc_OK+1
//	.skip 4
//	.word CustMenuPressAFunc_Block+1
//
//	.org CUST_OK_A_START_FREESPACE
//	.area 0x5E22 - 0x5DF0
//CustMenuPressAFunc_OK:
//	ldrh r0, [r7,oJoypad_Held]
//	mov r1, JOYPAD_START
//	tst r0, r1
//	beq CustMenuPressAFunc_NotHoldingStart
//	ldr r0, =sub_8028D3A+1
//	bx r0
//CustMenuPressAFunc_Block:
//	ldrh r0, [r7,oJoypad_Held]
//	mov r1, JOYPAD_START
//	tst r0, r1
//	beq CustMenuPressAFunc_NotHoldingStart
//	ldr r0, =sub_8028DBC+1
//	bx r0
//CustMenuPressAFunc_NotHoldingStart:
//	push {lr}
//	bl loc_8028D30
//// loc_8028D30 returns back to control
//	.pool
//	.endarea

	.close
