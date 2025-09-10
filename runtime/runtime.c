#include "src/deps.h"
#include "src/config.h"
#include "src/commands/index.h"

uint64_t begin(void);

int
main(int argc, char *argv[]) {
    uint64_t result = begin();
    printf("%u\n", result);
    return 0;
}
