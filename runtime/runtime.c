#include "src/deps.h"

int64_t begin(void);

int64_t random_dice(void) {
    return 6;
}

int
main(int argc, char *argv[]) {
    uint64_t result = begin();
    printf("%lld\n", result);
    return 0;
}
