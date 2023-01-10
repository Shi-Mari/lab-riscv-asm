

#include <stdio.h>


int main() {

    int nam_el = 1;
    int sum = 0;
    int array[4][4];
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            array[i][j] = (i + 1) * 10 + (j + 1);
            if (i == nam_el) {
                sum += array[i][j];
            }

        }
    }
    printf("%d", sum);
    printf("\n");
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++)
        {
            printf("[%d][%d]=%d ", i, j, array[i][j]);
        }
        printf("\n");
       
    }
    

}
