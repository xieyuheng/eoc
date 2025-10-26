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

static bool
gc_space_is_enough(gc_t* self, size_t size) {
    return self->free_pointer + size + 1 < self->from_space + self->from_size;
}

tuple_t *
gc_allocate_tuple(gc_t* self, size_t size) {
    if (gc_space_is_enough(self, size)) {
        tuple_t *tuple = self->from_space;
        self->from_space += size + 1; // + 1 for header
        return tuple;
    }

    // TODO gc_copy
    // TODO gc_grow
    return gc_allocate_tuple(self, size);
}
