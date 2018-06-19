//******************************************************************************
//
// Copyright (c) 2018 WANG,Jingkai. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************

#include "stdio.h"
#include "stdlib.h"
#include "string.h"

void println(int array[], int len) {
    int i = 0;

    for (i = 0; i < len; i++) {
        printf("%d ", array[i]);
    }

    printf("\n");
}
void swap(int array[], int i, int j) {
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
}

void ShellSort(int array[], int len) {
    int i    = 0;
    int j    = 0;
    int k    = -1;
    int temp = -1;
    int gap  = len;
    do {

        gap = gap / 3 + 1;

        for (i = gap; i < len; i += gap) {
            k    = i;
            temp = array[k];

            for (j = i - gap; (j >= 0) && (array[j] > temp); j -= gap) {
                array[j + gap] = array[j];
                k              = j;
            }

            array[k] = temp;
        }

    } while (gap > 1);
}

int partition(int array[], int low, int high) {
    int pv = array[low];

    while (low < high) {
        while ((low < high) && (array[high] >= pv)) {
            high--;
        }
        swap(array, low, high);
        while ((low < high) && (array[low] <= pv)) {
            low++;
        }
        swap(array, low, high);
    }

    return low;
}

void QSort2(int array[], int low, int high) {
    if (low < high) {
        int pivot = partition(array, low, high);

        QSort2(array, low, pivot - 1);
        QSort2(array, pivot + 1, high);
    }
}

void QSort(int array[], int low, int high) {
    if (low < high) {
        int pivot = partition(array, low, high);

        QSort2(array, low, pivot - 1);
        QSort2(array, pivot + 1, high);
    }
}

void QuickSort(int array[], int len) {
    QSort(array, 0, len - 1);
}

void Merge(const int src[], int des[], int low, int mid, int high) {
    int i = low;
    int j = mid + 1;
    int k = low;

    while ((i <= mid) && (j <= high)) {
        if (src[i] < src[j]) {
            des[k++] = src[i++];
        }
        else {
            des[k++] = src[j++];
        }
    }

    while (i <= mid) {
        des[k++] = src[i++];
    }

    while (j <= high) {
        des[k++] = src[j++];
    }
}

void MSort(int src[], int des[], int low, int high, int max) {
    if (low == high) {
        des[low] = src[low];
    }
    else {
        int  mid   = (low + high) / 2;
        int *space = (int *)malloc(sizeof(int) * max);

        if (space != NULL) {
            MSort(src, space, low, mid, max);
            MSort(src, space, mid + 1, high, max);
            Merge(space, des, low, mid, high);
        }

        free(space);
    }
}

void MergeSort(int array[], int len) {
    MSort(array, array, 0, len - 1, len);
}