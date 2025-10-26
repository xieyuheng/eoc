#include "index.h"

void
test_gc(void) {
    test_start();

    test_tuple();
    test_gc_copy();

    test_end();
}

void
test_gc_copy(void) {
    test_start();

    // EOC / Figure 6.5 / A copying collector in action.

    gc_t *gc = gc_new(8, 32);

    tuple_t *r0 = tuple_new(2, gc);
    tuple_t *r1 = tuple_new(3, gc);
    tuple_t *r2 = tuple_new(2, gc);

    gc_push_root(gc, r0);
    gc_push_root(gc, r1);
    gc_push_root(gc, r2);

    tuple_set_tuple(r0, 0, r1);

    test_end();
}
