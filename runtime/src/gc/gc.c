#include "index.h"

object_t* gc_root_stack_begin = NULL;
object_t* gc_root_stack_end = NULL;

object_t* gc_from_space_begin = NULL;
object_t* gc_from_space_end = NULL;

static object_t* gc_to_space_begin = NULL;
static object_t* gc_to_space_end = NULL;

object_t* gc_free_pointer = NULL;

static bool initialized = false;

void
gc_initialize(size_t root_stack_size, size_t heap_size) {
    if (initialized) return;

    gc_root_stack_begin = allocate_pointers(root_stack_size);
    gc_root_stack_end = gc_root_stack_begin + root_stack_size;

    gc_from_space_begin = allocate_pointers(heap_size);
    gc_from_space_end = gc_from_space_begin + heap_size;

    gc_to_space_begin = allocate_pointers(heap_size);
    gc_to_space_end = gc_to_space_begin + heap_size;

    gc_free_pointer = gc_from_space_begin;

    initialized = true;
}

void
gc_collect(object_t* root_stack_pointer, size_t size) {
    assert(initialized);
    assert(root_stack_pointer >= gc_root_stack_begin);
    assert(root_stack_pointer < gc_root_stack_end);

    (void) size;

    // cheney(root_stack_pointer);

    // TODO check there are enough space
    // to allocate memory of the given size (in words).
}
