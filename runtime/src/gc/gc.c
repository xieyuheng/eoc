#include "index.h"

object_t** gc_root_stack_begin = NULL;
object_t** gc_root_stack_end = NULL;

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
