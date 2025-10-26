#include "index.h"

void
test_gc(void) {
    test_start();

    gc_t *gc = gc_new(1024);

    {
        tuple_t *tuple = tuple_new(10, gc);
        assert(tuple_size(tuple) == 10);
    }

    {
        tuple_t *tuple = tuple_new(50, gc);
        assert(tuple_size(tuple) == 50);
    }

    {
        tuple_t *tuple = tuple_new(1, gc);
        assert(tuple_size(tuple) == 1);
    }


    test_end();
}
