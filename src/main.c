
#include <stdio.h>
#include <time.h>
#include "./famuz/famuz.h"

int main(int argc, char **argv)
{
	clock_t start, end;
	double cpu_time_used;
	start = clock();
	famuz_parse(argv[1]);
	end = clock();
	cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
	printf("%f", cpu_time_used);
	return 0;
}