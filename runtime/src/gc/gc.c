#include "index.h"

struct gc_t {
    void **from_space; size_t from_size;
    void **to_space; size_t to_size;
    void **free_pointer;
    void **scan_pointer;
};

gc_t *
gc_new(size_t initial_size) {
    gc_t *self = new(gc_t);
    self->from_space = allocate_pointers(initial_size);
    self->from_size = initial_size;
    self->to_space = allocate_pointers(initial_size);
    self->to_size = initial_size;
    self->free_pointer = self->from_space;
    self->scan_pointer = self->to_space;
    return self;
}

// void
// gc_collect(void **root_stack_pointer, size_t size) {
//     assert(initialized);
//     assert(root_stack_pointer >= gc_root_stack_begin);
//     assert(root_stack_pointer < gc_root_stack_end);

//     (void) size;

//     // TODO check there are enough space
//     // to allocate memory of the given size (in words).
// }
