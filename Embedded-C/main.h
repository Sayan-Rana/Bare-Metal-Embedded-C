/*
 * main.h
 *
 *  Created on: Oct 11, 2020
 *      Author: User
 */

#ifndef MAIN_H_
#define MAIN_H_

//Maximum number of task.
#define MAX_TASK				5
//Some stack memory calculation.
#define SIZE_TASK_STACK			1024U
#define SIZE_SCHED_STACK		1024U

#define SRAM_START				0X20000000U
#define SIZE_SRAM				( (128) * (1024) )
#define SRAM_END				( (SRAM_START) + (SIZE_SRAM) )

#define T1_STACK_START			SRAM_END
#define T2_STACK_START			( (SRAM_END) - (1 * SIZE_TASK_STACK) )
#define T3_STACK_START			( (SRAM_END) - (2 * SIZE_TASK_STACK) )
#define T4_STACK_START			( (SRAM_END) - (3 * SIZE_TASK_STACK) )
#define IDLE_STACK_START		( (SRAM_END) - (4 * SIZE_TASK_STACK) )
#define SCHED_STACK_START		( (SRAM_END) - (5 * SIZE_TASK_STACK) )

//SYSTICK timer count clock / HSI clock of the MICROCONTROLLER
#define SYSTICK_TIM_CLK			16000000U  //16MHz

//Desired exception frequency
#define TICK_HZ					1000U

#define DUMMY_xPSR				0x01000000U

#define TASK_READY_STATE		0x00
#define TASK_BLOCKED_STATE		0xFF

//Disabling all interrupts.
#define INTERRUPT_DISABLE()		do{__asm volatile ("MOV R0,#0x1"); __asm volatile ("MSR PRIMASK,R0");}while(0)

//Enabling all interrupts.
#define INTERRUPT_ENABLE()		do{__asm volatile ("MOV R0,#0x0"); __asm volatile ("MSR PRIMASK,R0");}while(0)



#endif /* MAIN_H_ */
