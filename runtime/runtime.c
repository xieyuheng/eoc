#include "src/deps.h"
#include "src/config.h"
#include "src/commands/index.h"

uint64_t start(void);

int
main(int argc, char *argv[]) {
    uint64_t result = start();
    printf("%u\n", result);
    return 0;
}
