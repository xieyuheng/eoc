#include "index.h"

void
test_gc(void) {
    test_start();

    gc_initialize(1024, 1024);
    gc_collect(gc_root_stack_begin, 10);

    tuple_t *tuple = tuple_new(10);
    (void) tuple;

    test_end();
}
