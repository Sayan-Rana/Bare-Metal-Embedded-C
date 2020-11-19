/*Created by Sayan Rana */
#include <stdio.h>
#include <stdint.h>
#include "main.h"
#include "led.h"



void task1_handler(void);  //This is task_1
void task2_handler(void);  //This is task_2
void task3_handler(void);  //This is task_3
void task4_handler(void);  //This is task_4
void idle_task(void);	   //This is idle_task


void init_systic_timer(uint32_t tick_hz);
__attribute__ ((naked)) void init_scheduler_stack(uint32_t sched_top_of_stack);
void init_task_stack(void);
void enable_precessor_faults(void);
uint32_t get_psp_value(void);
__attribute__ ((naked)) void switch_sp_to_psp(void);

void task_delay(uint32_t tick_count);
void update_next_task(void);
void schedule(void);
void unblock_tasks(void);



uint8_t current_task = 1;   //Task1 will run at the very beginning.
uint32_t g_tick_count = 0;  //Global tick count

const uint32_t const_v_1 = 100;  //Some constant variable to chech .rodata section
const uint32_t const_v_2 = 100;  //Some constant variable to chech .rodata section
const uint8_t  const_v_3 = 50;


typedef struct
{
	uint32_t psp_value;
	uint32_t block_count;
	uint8_t  current_state;
	void (*task_handler)(void);
}TCB_t;

TCB_t user_task[MAX_TASK];

//this is semihosting init function
extern void initialise_monitor_handles(void);



int main(void)
{
	enable_precessor_faults();
	
	//Before using semihosting we have to call this function
	initialise_monitor_handles();	

	init_scheduler_stack(SCHED_STACK_START);
	
	printf("Implementation of simple task scheduler\n");

	init_task_stack(); //Creating dummy stack frame.

	led_init_all();

	init_systic_timer(TICK_HZ);

	switch_sp_to_psp();

	task1_handler();

	for(;;);
}


void idle_task(void)
{
	while(1);
}


void task1_handler(void)
{
	while(1)
	{
		printf("Task 1 is executing\n");
		led_on(LED_GREEN);
		task_delay(1000);
		led_off(LED_GREEN);
		task_delay(1000);
	}
}


void task2_handler(void)
{
	while(1)
	{
		printf("Task 2 is executing\n");
		led_on(LED_ORANGE);
		task_delay(500);
		led_off(LED_ORANGE);
		task_delay(500);
	}
}


void task3_handler(void)
{
	while(1)
	{
		printf("Task 3 is executing\n");
		led_on(LED_RED);
		task_delay(250);
		led_off(LED_RED);
		task_delay(250);
	}
}


void task4_handler(void)
{
	while(1)
	{
		printf("Task 4 is executing\n");
		led_on(LED_BLUE);
		task_delay(125);
		led_off(LED_BLUE);
		task_delay(125);
	}
}


void init_systic_timer(uint32_t tick_hz)
{
	//Address of SYSTICK reload value resister.
	uint32_t *pSYST_RVR = (uint32_t*)0xE000E014;
	//SYSTICk control and status register.
	uint32_t *pSYST_CSR = (uint32_t*)0xE000E010;

	//Reload value calculation.
	uint32_t count_value = (SYSTICK_TIM_CLK/tick_hz);

	//Clear the value of SYST_RVR(reload value resister).
	*pSYST_RVR &= ~(0x00FFFFFF);
	//Load the value into SYST_RVR(reload value resister).
	*pSYST_RVR |= (count_value -1); //-1 is required due to SYSTICK exception will triggered after copying the value from RVR to CVR.

	//Do some settings
	*pSYST_CSR |= (0x1 << 1);  //Enable SYSTICK exception request.
	*pSYST_CSR |= (0x1 << 2);  //Indicate the clock source, processor clock source.

	//Enable the SYSTICK
	*pSYST_CSR |= (0x1 << 0);  // Enable the SYSTICK counter.

}


__attribute__ ((naked)) void init_scheduler_stack(uint32_t sched_top_of_stack)
{
	//Using general purpose register to move the value in MSP.
	//__asm volatile ("MSR MSP,R0");

	//Using GCC inline assembly syntax using C variable.
	__asm volatile ("MSR MSP,%0"::"r"(sched_top_of_stack): );

	//Loading the value of LR into PC because this is a naked function and we must go back to main after executing this function.
	//Naked function does not have any epilogue and prologue sequence.
	__asm volatile ("BX LR");
}


void init_task_stack(void)
{
	user_task[0].current_state = TASK_READY_STATE;
	user_task[1].current_state = TASK_READY_STATE;
	user_task[2].current_state = TASK_READY_STATE;
	user_task[3].current_state = TASK_READY_STATE;
	user_task[4].current_state = TASK_READY_STATE;

	user_task[0].psp_value = IDLE_STACK_START;
	user_task[1].psp_value = T1_STACK_START;
	user_task[2].psp_value = T2_STACK_START;
	user_task[3].psp_value = T3_STACK_START;
	user_task[4].psp_value = T4_STACK_START;

	user_task[0].task_handler = idle_task;
	user_task[1].task_handler = task1_handler;
	user_task[2].task_handler = task2_handler;
	user_task[3].task_handler = task3_handler;
	user_task[4].task_handler = task4_handler;

	uint32_t *pPSP;
	for(int i = 0; i < MAX_TASK; i++)
	{
		pPSP = (uint32_t*)user_task[i].psp_value;

		pPSP--;
		*pPSP = DUMMY_xPSR; //value should be 0x01000000.

		pPSP--;
		*pPSP = (uint32_t)user_task[i].task_handler;  //PC value.

		pPSP--;
		*pPSP = 0xFFFFFFFD;  //LR value.

		for(int j = 0; j < 13; j++)
		{
			pPSP--;
			*pPSP = 0;
		}
		//Saving the address of the stack pointer(in this case PSP).
		user_task[i].psp_value = (uint32_t)pPSP;
	}
}


void enable_precessor_faults(void)
{
    //1. Enable all configurable fault exceptions like usage fault, mem manage fault and bus fault.
	uint32_t *pSHCSR = (uint32_t*)0xE000ED24;
	*pSHCSR |= (1<<16); //Activate mem manage fault.
	*pSHCSR |= (1<<17); //Activate bus fault.
	*pSHCSR |= (1<<18); //Activate usage fault.
}


uint32_t get_psp_value(void)
{
	return user_task[current_task].psp_value;
}


void save_psp_value(uint32_t current_psp_value)
{
	user_task[current_task].psp_value = current_psp_value;
}


void update_next_task(void)
{
	uint8_t state = TASK_BLOCKED_STATE;

	uint8_t user_task_counter = 0;

	while(user_task_counter < MAX_TASK)
	{
		//current_task++;
		//current_task %= MAX_TASK;

		state = user_task[user_task_counter].current_state;

		if(state == TASK_READY_STATE && user_task_counter != 0)
		{
			current_task = user_task_counter;
			break;
		}

		user_task_counter++;
	}

	if(state != TASK_READY_STATE)
		current_task = 0;

}


__attribute__ ((naked)) void switch_sp_to_psp(void)
{
	//1. Initialize the PSP with Task1 stack start address.

	//Get the value of the PSP of the current task.
	__asm volatile ("PUSH {LR}"); //Preserve LR into stack, which connects back to main()
	__asm volatile ("BL get_psp_value");
	__asm volatile ("MSR PSP,R0"); //Initialize PSP.
	__asm volatile ("POP {LR}"); // Pops back LR value.

	//2. Change SP to PSP using Control register.
	__asm volatile ("MOV R0,#0x02");
	__asm volatile("MSR CONTROL,R0");
	__asm volatile ("BX LR");
}


void schedule(void)
{
	//Pend the pendSV exception in Interrupt control and State Register.

	uint32_t *pICSR = (uint32_t*)0xE000ED04;
	*pICSR |= (0x1 << 28);
}


void task_delay(uint32_t tick_count)
{
	//Disable interrupts before accessing global data.
	INTERRUPT_DISABLE();

	if(current_task)
	{
		user_task[current_task].block_count   = g_tick_count + tick_count;
		user_task[current_task].current_state = TASK_BLOCKED_STATE;
		schedule();
	}

	//After finish the access enable the interrupts.
	INTERRUPT_ENABLE();
}


__attribute__ ((naked)) void PendSV_Handler(void)
{
	/*Save the context of the current task*/

	//1. Get current running task's PSP value.
	__asm volatile ("MRS R0,PSP");
	//2. Using that PSP value store SF2(R4 to R11).
	__asm volatile ("STMDB R0!,{R4-R11}");

	//First we have to save the LR value of the calling function before call any function.
	__asm volatile ("PUSH {LR}");

	//3. Save the current current value of the PSP.
	__asm volatile ("BL save_psp_value");



	/*Retrieve the context of the next task*/

	//1. Decide next task to run.
	__asm volatile ("BL update_next_task");

	//2. Get its past PSP value.
	__asm volatile ("BL get_psp_value");

	//3. Using that PSP value retrieve SF2(R4 to R11).
	__asm volatile ("LDMIA R0!,{R4-R11}");

	//4. Update PSP and exit.
	__asm volatile ("MSR PSP,R0");

	//After function call we have to POP back the LR value.
	__asm volatile ("POP {LR}");

	__asm volatile ("BX LR");
}


/*void update_global_tick_count(void)
{
	g_tick_count++;
}*/


void unblock_tasks(void)
{
	for(int i = 1; i < MAX_TASK; i++)
	{
		if(user_task[i].current_state != TASK_READY_STATE)
		{
			if(user_task[i].block_count == g_tick_count)
			{
				user_task[i].current_state = TASK_READY_STATE;
			}
		}
	}
}


void SysTick_Handler(void)
{
	g_tick_count++;

	unblock_tasks();


	//Pend the pendSV exception in Interrupt control and State Register.

	uint32_t *pICSR = (uint32_t*)0xE000ED04;
	*pICSR |= (0x1 << 28);

}


void HardFault_Handler(void)
{
	printf("Fault : HardFault_Handler\n");
	while(1);
}


void MemManage_Handler(void)
{
	printf("Fault : MemManage_Handler\n");
	while(1);
}


void BusFault_Handler(void)
{
	printf("Fault : BusFault_Handler\n");
	while(1);
}


void UsageFault_Handler(void)
{
	printf("Fault : UsageFault_Handler\n");
	while(1);
}

