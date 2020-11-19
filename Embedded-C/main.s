	.cpu cortex-m4
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"main.c"
	.text
	.global	current_task
	.data
	.type	current_task, %object
	.size	current_task, 1
current_task:
	.byte	1
	.global	g_tick_count
	.bss
	.align	2
	.type	g_tick_count, %object
	.size	g_tick_count, 4
g_tick_count:
	.space	4
	.comm	user_task,80,4
	.text
	.align	1
	.global	main
	.arch armv7e-m
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	bl	enable_precessor_faults
	ldr	r0, .L3
	bl	init_scheduler_stack
	bl	init_task_stack
	bl	led_init_all
	mov	r0, #1000
	bl	init_systic_timer
	bl	switch_sp_to_psp
	bl	task1_handler
.L2:
	b	.L2
.L4:
	.align	2
.L3:
	.word	536996864
	.size	main, .-main
	.align	1
	.global	idle_task
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	idle_task, %function
idle_task:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
.L6:
	b	.L6
	.size	idle_task, .-idle_task
	.align	1
	.global	task1_handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task1_handler, %function
task1_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
.L8:
	movs	r0, #12
	bl	led_on
	mov	r0, #1000
	bl	task_delay
	movs	r0, #12
	bl	led_off
	mov	r0, #1000
	bl	task_delay
	b	.L8
	.size	task1_handler, .-task1_handler
	.align	1
	.global	task2_handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task2_handler, %function
task2_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
.L10:
	movs	r0, #13
	bl	led_on
	mov	r0, #500
	bl	task_delay
	movs	r0, #13
	bl	led_off
	mov	r0, #500
	bl	task_delay
	b	.L10
	.size	task2_handler, .-task2_handler
	.align	1
	.global	task3_handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task3_handler, %function
task3_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
.L12:
	movs	r0, #14
	bl	led_on
	movs	r0, #250
	bl	task_delay
	movs	r0, #14
	bl	led_off
	movs	r0, #250
	bl	task_delay
	b	.L12
	.size	task3_handler, .-task3_handler
	.align	1
	.global	task4_handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task4_handler, %function
task4_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
.L14:
	movs	r0, #15
	bl	led_on
	movs	r0, #125
	bl	task_delay
	movs	r0, #15
	bl	led_off
	movs	r0, #125
	bl	task_delay
	b	.L14
	.size	task4_handler, .-task4_handler
	.align	1
	.global	init_systic_timer
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	init_systic_timer, %function
init_systic_timer:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #28
	add	r7, sp, #0
	str	r0, [r7, #4]
	ldr	r3, .L16
	str	r3, [r7, #20]
	ldr	r3, .L16+4
	str	r3, [r7, #16]
	ldr	r2, .L16+8
	ldr	r3, [r7, #4]
	udiv	r3, r2, r3
	str	r3, [r7, #12]
	ldr	r3, [r7, #20]
	ldr	r3, [r3]
	and	r2, r3, #-16777216
	ldr	r3, [r7, #20]
	str	r2, [r3]
	ldr	r3, [r7, #20]
	ldr	r2, [r3]
	ldr	r3, [r7, #12]
	subs	r3, r3, #1
	orrs	r2, r2, r3
	ldr	r3, [r7, #20]
	str	r2, [r3]
	ldr	r3, [r7, #16]
	ldr	r3, [r3]
	orr	r2, r3, #2
	ldr	r3, [r7, #16]
	str	r2, [r3]
	ldr	r3, [r7, #16]
	ldr	r3, [r3]
	orr	r2, r3, #4
	ldr	r3, [r7, #16]
	str	r2, [r3]
	ldr	r3, [r7, #16]
	ldr	r3, [r3]
	orr	r2, r3, #1
	ldr	r3, [r7, #16]
	str	r2, [r3]
	nop
	adds	r7, r7, #28
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L17:
	.align	2
.L16:
	.word	-536813548
	.word	-536813552
	.word	16000000
	.size	init_systic_timer, .-init_systic_timer
	.align	1
	.global	init_scheduler_stack
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	init_scheduler_stack, %function
init_scheduler_stack:
	@ Naked Function: prologue and epilogue provided by programmer.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	r3, r0
	.syntax unified
@ 151 "main.c" 1
	MSR MSP,r3
@ 0 "" 2
@ 155 "main.c" 1
	BX LR
@ 0 "" 2
	.thumb
	.syntax unified
	nop
	.size	init_scheduler_stack, .-init_scheduler_stack
	.align	1
	.global	init_task_stack
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	init_task_stack, %function
init_task_stack:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #20
	add	r7, sp, #0
	ldr	r3, .L24
	movs	r2, #0
	strb	r2, [r3, #8]
	ldr	r3, .L24
	movs	r2, #0
	strb	r2, [r3, #24]
	ldr	r3, .L24
	movs	r2, #0
	strb	r2, [r3, #40]
	ldr	r3, .L24
	movs	r2, #0
	strb	r2, [r3, #56]
	ldr	r3, .L24
	movs	r2, #0
	strb	r2, [r3, #72]
	ldr	r3, .L24
	ldr	r2, .L24+4
	str	r2, [r3]
	ldr	r3, .L24
	ldr	r2, .L24+8
	str	r2, [r3, #16]
	ldr	r3, .L24
	ldr	r2, .L24+12
	str	r2, [r3, #32]
	ldr	r3, .L24
	ldr	r2, .L24+16
	str	r2, [r3, #48]
	ldr	r3, .L24
	ldr	r2, .L24+20
	str	r2, [r3, #64]
	ldr	r3, .L24
	ldr	r2, .L24+24
	str	r2, [r3, #12]
	ldr	r3, .L24
	ldr	r2, .L24+28
	str	r2, [r3, #28]
	ldr	r3, .L24
	ldr	r2, .L24+32
	str	r2, [r3, #44]
	ldr	r3, .L24
	ldr	r2, .L24+36
	str	r2, [r3, #60]
	ldr	r3, .L24
	ldr	r2, .L24+40
	str	r2, [r3, #76]
	movs	r3, #0
	str	r3, [r7, #8]
	b	.L20
.L23:
	ldr	r2, .L24
	ldr	r3, [r7, #8]
	lsls	r3, r3, #4
	add	r3, r3, r2
	ldr	r3, [r3]
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	subs	r3, r3, #4
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	mov	r2, #16777216
	str	r2, [r3]
	ldr	r3, [r7, #12]
	subs	r3, r3, #4
	str	r3, [r7, #12]
	ldr	r2, .L24
	ldr	r3, [r7, #8]
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #12
	ldr	r3, [r3]
	mov	r2, r3
	ldr	r3, [r7, #12]
	str	r2, [r3]
	ldr	r3, [r7, #12]
	subs	r3, r3, #4
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	mvn	r2, #2
	str	r2, [r3]
	movs	r3, #0
	str	r3, [r7, #4]
	b	.L21
.L22:
	ldr	r3, [r7, #12]
	subs	r3, r3, #4
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	movs	r2, #0
	str	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r3, r3, #1
	str	r3, [r7, #4]
.L21:
	ldr	r3, [r7, #4]
	cmp	r3, #12
	ble	.L22
	ldr	r2, [r7, #12]
	ldr	r1, .L24
	ldr	r3, [r7, #8]
	lsls	r3, r3, #4
	add	r3, r3, r1
	str	r2, [r3]
	ldr	r3, [r7, #8]
	adds	r3, r3, #1
	str	r3, [r7, #8]
.L20:
	ldr	r3, [r7, #8]
	cmp	r3, #4
	ble	.L23
	nop
	nop
	adds	r7, r7, #20
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L25:
	.align	2
.L24:
	.word	user_task
	.word	536997888
	.word	537001984
	.word	537000960
	.word	536999936
	.word	536998912
	.word	idle_task
	.word	task1_handler
	.word	task2_handler
	.word	task3_handler
	.word	task4_handler
	.size	init_task_stack, .-init_task_stack
	.align	1
	.global	enable_precessor_faults
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	enable_precessor_faults, %function
enable_precessor_faults:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	ldr	r3, .L27
	str	r3, [r7, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	orr	r2, r3, #65536
	ldr	r3, [r7, #4]
	str	r2, [r3]
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	orr	r2, r3, #131072
	ldr	r3, [r7, #4]
	str	r2, [r3]
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	orr	r2, r3, #262144
	ldr	r3, [r7, #4]
	str	r2, [r3]
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L28:
	.align	2
.L27:
	.word	-536810204
	.size	enable_precessor_faults, .-enable_precessor_faults
	.align	1
	.global	get_psp_value
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	get_psp_value, %function
get_psp_value:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
	ldr	r3, .L31
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r2, .L31+4
	lsls	r3, r3, #4
	add	r3, r3, r2
	ldr	r3, [r3]
	mov	r0, r3
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L32:
	.align	2
.L31:
	.word	current_task
	.word	user_task
	.size	get_psp_value, .-get_psp_value
	.align	1
	.global	save_psp_value
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	save_psp_value, %function
save_psp_value:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	str	r0, [r7, #4]
	ldr	r3, .L34
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r2, .L34+4
	lsls	r3, r3, #4
	add	r3, r3, r2
	ldr	r2, [r7, #4]
	str	r2, [r3]
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L35:
	.align	2
.L34:
	.word	current_task
	.word	user_task
	.size	save_psp_value, .-save_psp_value
	.align	1
	.global	update_next_task
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	update_next_task, %function
update_next_task:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	movs	r3, #255
	strb	r3, [r7, #7]
	movs	r3, #0
	strb	r3, [r7, #6]
	b	.L37
.L40:
	ldrb	r3, [r7, #6]	@ zero_extendqisi2
	ldr	r2, .L43
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #8
	ldrb	r3, [r3]
	strb	r3, [r7, #7]
	ldrb	r3, [r7, #7]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L38
	ldrb	r3, [r7, #6]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L38
	ldr	r2, .L43+4
	ldrb	r3, [r7, #6]
	strb	r3, [r2]
	b	.L39
.L38:
	ldrb	r3, [r7, #6]	@ zero_extendqisi2
	adds	r3, r3, #1
	strb	r3, [r7, #6]
.L37:
	ldrb	r3, [r7, #6]	@ zero_extendqisi2
	cmp	r3, #4
	bls	.L40
.L39:
	ldrb	r3, [r7, #7]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L42
	ldr	r3, .L43+4
	movs	r2, #0
	strb	r2, [r3]
.L42:
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L44:
	.align	2
.L43:
	.word	user_task
	.word	current_task
	.size	update_next_task, .-update_next_task
	.align	1
	.global	switch_sp_to_psp
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	switch_sp_to_psp, %function
switch_sp_to_psp:
	@ Naked Function: prologue and epilogue provided by programmer.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	.syntax unified
@ 259 "main.c" 1
	PUSH {LR}
@ 0 "" 2
@ 260 "main.c" 1
	BL get_psp_value
@ 0 "" 2
@ 261 "main.c" 1
	MSR PSP,R0
@ 0 "" 2
@ 262 "main.c" 1
	POP {LR}
@ 0 "" 2
@ 265 "main.c" 1
	MOV R0,#0x02
@ 0 "" 2
@ 266 "main.c" 1
	MSR CONTROL,R0
@ 0 "" 2
@ 267 "main.c" 1
	BX LR
@ 0 "" 2
	.thumb
	.syntax unified
	nop
	.size	switch_sp_to_psp, .-switch_sp_to_psp
	.align	1
	.global	schedule
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	schedule, %function
schedule:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	ldr	r3, .L47
	str	r3, [r7, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	orr	r2, r3, #268435456
	ldr	r3, [r7, #4]
	str	r2, [r3]
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L48:
	.align	2
.L47:
	.word	-536810236
	.size	schedule, .-schedule
	.align	1
	.global	task_delay
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	task_delay, %function
task_delay:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	str	r0, [r7, #4]
	.syntax unified
@ 283 "main.c" 1
	MOV R0,#0x1
@ 0 "" 2
@ 283 "main.c" 1
	MSR PRIMASK,R0
@ 0 "" 2
	.thumb
	.syntax unified
	ldr	r3, .L51
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L50
	ldr	r3, .L51+4
	ldr	r2, [r3]
	ldr	r3, .L51
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r0, r3
	ldr	r3, [r7, #4]
	add	r2, r2, r3
	ldr	r1, .L51+8
	lsls	r3, r0, #4
	add	r3, r3, r1
	adds	r3, r3, #4
	str	r2, [r3]
	ldr	r3, .L51
	ldrb	r3, [r3]	@ zero_extendqisi2
	ldr	r2, .L51+8
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #8
	movs	r2, #255
	strb	r2, [r3]
	bl	schedule
.L50:
	.syntax unified
@ 293 "main.c" 1
	MOV R0,#0x0
@ 0 "" 2
@ 293 "main.c" 1
	MSR PRIMASK,R0
@ 0 "" 2
	.thumb
	.syntax unified
	nop
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
.L52:
	.align	2
.L51:
	.word	current_task
	.word	g_tick_count
	.word	user_task
	.size	task_delay, .-task_delay
	.align	1
	.global	PendSV_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	PendSV_Handler, %function
PendSV_Handler:
	@ Naked Function: prologue and epilogue provided by programmer.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	.syntax unified
@ 302 "main.c" 1
	MRS R0,PSP
@ 0 "" 2
@ 304 "main.c" 1
	STMDB R0!,{R4-R11}
@ 0 "" 2
@ 307 "main.c" 1
	PUSH {LR}
@ 0 "" 2
@ 310 "main.c" 1
	BL save_psp_value
@ 0 "" 2
@ 317 "main.c" 1
	BL update_next_task
@ 0 "" 2
@ 320 "main.c" 1
	BL get_psp_value
@ 0 "" 2
@ 323 "main.c" 1
	LDMIA R0!,{R4-R11}
@ 0 "" 2
@ 326 "main.c" 1
	MSR PSP,R0
@ 0 "" 2
@ 329 "main.c" 1
	POP {LR}
@ 0 "" 2
@ 331 "main.c" 1
	BX LR
@ 0 "" 2
	.thumb
	.syntax unified
	nop
	.size	PendSV_Handler, .-PendSV_Handler
	.align	1
	.global	unblock_tasks
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	unblock_tasks, %function
unblock_tasks:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	movs	r3, #1
	str	r3, [r7, #4]
	b	.L55
.L57:
	ldr	r2, .L58
	ldr	r3, [r7, #4]
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #8
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L56
	ldr	r2, .L58
	ldr	r3, [r7, #4]
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #4
	ldr	r2, [r3]
	ldr	r3, .L58+4
	ldr	r3, [r3]
	cmp	r2, r3
	bne	.L56
	ldr	r2, .L58
	ldr	r3, [r7, #4]
	lsls	r3, r3, #4
	add	r3, r3, r2
	adds	r3, r3, #8
	movs	r2, #0
	strb	r2, [r3]
.L56:
	ldr	r3, [r7, #4]
	adds	r3, r3, #1
	str	r3, [r7, #4]
.L55:
	ldr	r3, [r7, #4]
	cmp	r3, #4
	ble	.L57
	nop
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L59:
	.align	2
.L58:
	.word	user_task
	.word	g_tick_count
	.size	unblock_tasks, .-unblock_tasks
	.align	1
	.global	SysTick_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	SysTick_Handler, %function
SysTick_Handler:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #8
	add	r7, sp, #0
	ldr	r3, .L61
	ldr	r3, [r3]
	adds	r3, r3, #1
	ldr	r2, .L61
	str	r3, [r2]
	bl	unblock_tasks
	ldr	r3, .L61+4
	str	r3, [r7, #4]
	ldr	r3, [r7, #4]
	ldr	r3, [r3]
	orr	r2, r3, #268435456
	ldr	r3, [r7, #4]
	str	r2, [r3]
	nop
	adds	r7, r7, #8
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
.L62:
	.align	2
.L61:
	.word	g_tick_count
	.word	-536810236
	.size	SysTick_Handler, .-SysTick_Handler
	.section	.rodata
	.align	2
.LC0:
	.ascii	"Fault : HardFault_Handler\000"
	.text
	.align	1
	.global	HardFault_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	HardFault_Handler, %function
HardFault_Handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	ldr	r0, .L65
	bl	puts
.L64:
	b	.L64
.L66:
	.align	2
.L65:
	.word	.LC0
	.size	HardFault_Handler, .-HardFault_Handler
	.section	.rodata
	.align	2
.LC1:
	.ascii	"Fault : MemManage_Handler\000"
	.text
	.align	1
	.global	MemManage_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	MemManage_Handler, %function
MemManage_Handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	ldr	r0, .L69
	bl	puts
.L68:
	b	.L68
.L70:
	.align	2
.L69:
	.word	.LC1
	.size	MemManage_Handler, .-MemManage_Handler
	.section	.rodata
	.align	2
.LC2:
	.ascii	"Fault : BusFault_Handler\000"
	.text
	.align	1
	.global	BusFault_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	BusFault_Handler, %function
BusFault_Handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	ldr	r0, .L73
	bl	puts
.L72:
	b	.L72
.L74:
	.align	2
.L73:
	.word	.LC2
	.size	BusFault_Handler, .-BusFault_Handler
	.section	.rodata
	.align	2
.LC3:
	.ascii	"Fault : UsageFault_Handler\000"
	.text
	.align	1
	.global	UsageFault_Handler
	.syntax unified
	.thumb
	.thumb_func
	.fpu softvfp
	.type	UsageFault_Handler, %function
UsageFault_Handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	ldr	r0, .L77
	bl	puts
.L76:
	b	.L76
.L78:
	.align	2
.L77:
	.word	.LC3
	.size	UsageFault_Handler, .-UsageFault_Handler
	.ident	"GCC: (GNU Arm Embedded Toolchain 9-2020-q2-update) 9.3.1 20200408 (release)"
