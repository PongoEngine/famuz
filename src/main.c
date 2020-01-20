
#include <stdio.h>
#include <time.h>
#include "./famuz/famuz.h"

int main()
{
	clock_t start, end;
	double cpu_time_used;
	start = clock();
	famuz_parse("./data/test.famuz");
	end = clock();
	cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
	// printf("%f", cpu_time_used);
	return 0;
}