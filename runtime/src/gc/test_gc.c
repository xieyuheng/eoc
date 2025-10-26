#include "index.h"

void
test_gc(void) {
    test_start();

    gc_t *gc = gc_new(1024);
    tuple_t *tuple = gc_allocate_tuple(gc, 10);
    (void) tuple;

    // gc_initialize(1024, 1024);
    // gc_collect(gc_root_stack_begin, 10);

    {
        tuple_t *tuple = tuple_new(10);
        assert(tuple_size(tuple) == 10);
    }

    {
        tuple_t *tuple = tuple_new(50);
        assert(tuple_size(tuple) == 50);
    }

    {
        tuple_t *tuple = tuple_new(1);
        assert(tuple_size(tuple) == 1);
    }


    test_end();
}
