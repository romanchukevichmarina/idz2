#include <stdio.h>
#include <stdlib.h>


void findNums(FILE *input, int i, int n, char *nums);

int main(int argc, char **argv) {
    FILE *input, *output;
    int i = 0, n;
    input = fopen("input.txt", "r");
    fseek(input, 0L, SEEK_END);
    n = ftell(input);
    fseek(input, 0L, SEEK_SET);
    char *nums = (char *) malloc(n * 2 - 1);
    findNums(input, i, n, nums);
    fclose(input);
    output = fopen("output.txt", "w");
    fputs(nums, output);
    fclose(output);
    return 0;
}

void findNums(FILE *input, int i, int n, char *nums) {
    char *str = (char *) malloc(n);
    int j = 0;
    while (i != n) {
        fscanf(input, "%c", &str[i]);
        if (str[i] >= 48 && str[i] <= 57) {
            if ((str[i - 1] < 48 || str[i - 1] > 57) && j != 0) {
                nums[j] = '+';
                j++;
            }
            nums[j] = str[i];
            ++j;
        }
        ++i;
    }
}
