#include "index.h"

object_t** gc_root_stack_begin = NULL;
object_t** gc_root_stack_end = NULL;

object_t* gc_free_pointer = NULL;

object_t* gc_from_space_begin = NULL;
object_t* gc_from_space_end = NULL;

static object_t* gc_to_space_begin = NULL;
static object_t* gc_to_space_end = NULL;

void
gc_initialize(size_t root_stack_size, size_t heap_size) {
    assert(sizeof(object_t) == 8);

    assert(root_stack_size % 8 == 0);
    assert(heap_size % 8 == 0);

    gc_root_stack_begin = allocate(root_stack_size);
    gc_root_stack_end = gc_root_stack_begin + root_stack_size / 8;

    gc_from_space_begin = allocate(heap_size);
    gc_from_space_end = gc_from_space_begin + heap_size / 8;

    gc_to_space_begin = allocate(heap_size);
    gc_to_space_end = gc_to_space_begin + heap_size / 8;
}
