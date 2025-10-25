#include "src/deps.h"
#include "src/gc/index.h"

int64_t begin(void);

int64_t random_dice(void) {
    return 6;
}

int
main(int argc, char *argv[]) {
    gc_initialize(1024, 1024);
    object_t *root_stack_pointer = gc_root_stack_begin;
    size_t bytes_requested = 1024;
    gc_collect(root_stack_pointer, bytes_requested);

    uint64_t result = begin();
    printf("%lld\n", result);
    return 0;
}
