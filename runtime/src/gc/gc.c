#include "index.h"

void **gc_root_stack_begin = NULL;
void **gc_root_stack_end = NULL;

void **gc_from_space_begin = NULL;
void **gc_from_space_end = NULL;

static void **gc_to_space_begin = NULL;
static void **gc_to_space_end = NULL;

void **gc_free_pointer = NULL;

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

static void cheney(void **root_stack_pointer);

void
gc_collect(void **root_stack_pointer, size_t size) {
    assert(initialized);
    assert(root_stack_pointer >= gc_root_stack_begin);
    assert(root_stack_pointer < gc_root_stack_end);

    (void) size;

    cheney(root_stack_pointer);

    // TODO check there are enough space
    // to allocate memory of the given size (in words).
}

static void
cheney(void **root_stack_pointer) {
    assert(root_stack_pointer);
    void **gc_scan_pointer = gc_to_space_begin;
    gc_free_pointer = gc_to_space_begin;

    // prepare queue
    (void) gc_scan_pointer;
}
