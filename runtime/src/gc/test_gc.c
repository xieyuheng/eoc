#include "index.h"

void
test_gc(void) {
    test_start();

    test_tuple();

    test_end();
}

void
test_tuple(void) {
    test_start();

    gc_t *gc = gc_new(1024);

    tuple_t *t1 = tuple_new(10, gc);
    assert(tuple_size(t1) == 10);

    tuple_t *t2 = tuple_new(3, gc);
    assert(tuple_size(t2) == 3);

    {
        tuple_set_atom(t2, 0, 0);
        tuple_set_atom(t2, 1, 1);
        tuple_set_atom(t2, 2, 2);

        assert(tuple_is_atom_index(t2, 0));
        assert(tuple_is_atom_index(t2, 1));
        assert(tuple_is_atom_index(t2, 2));

        assert(!tuple_is_object_index(t2, 0));
        assert(!tuple_is_object_index(t2, 1));
        assert(!tuple_is_object_index(t2, 2));

        assert(tuple_get_atom(t2, 0) == 0);
        assert(tuple_get_atom(t2, 1) == 1);
        assert(tuple_get_atom(t2, 2) == 2);
    }

    tuple_set_object(t1, 0, t2);
    tuple_set_atom(t1, 1, 100);
    tuple_set_atom(t1, 2, 200);
    tuple_set_object(t1, 3, t2);

    assert(tuple_is_object_index(t1, 0));
    assert(tuple_is_atom_index(t1, 1));
    assert(tuple_is_atom_index(t1, 2));
    assert(tuple_is_object_index(t1, 3));

    assert(tuple_get_object(t1, 0) == t2);
    assert(tuple_get_atom(t1, 1) == 100);
    assert(tuple_get_atom(t1, 2) == 200);
    assert(tuple_get_object(t1, 3) == t2);

    test_end();
}
