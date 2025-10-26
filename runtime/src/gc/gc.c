#include "index.h"

struct gc_t {
    void **root_space; size_t root_size;
    void **root_pointer;
    void **from_space; size_t from_size;
    void **to_space; size_t to_size;
    void **free_pointer;
    void **scan_pointer;
};

gc_t *
gc_new(size_t root_size, size_t heap_size) {
    gc_t *self = new(gc_t);
    self->root_space = allocate_pointers(root_size);
    self->root_pointer = self->root_space;
    self->root_size = root_size;
    self->from_space = allocate_pointers(heap_size);
    self->from_size = heap_size;
    self->to_space = allocate_pointers(heap_size);
    self->to_size = heap_size;
    self->free_pointer = self->from_space;
    self->scan_pointer = self->to_space;
    return self;
}

static bool
gc_space_is_enough(gc_t* self, size_t size) {
    return self->free_pointer + size + 1 < self->from_space + self->from_size;
}

static void gc_copy(gc_t* self);
static void gc_grow(gc_t* self);

tuple_t *
gc_allocate_tuple(gc_t* self, size_t size) {
    if (gc_space_is_enough(self, size)) {
        tuple_t *tuple = self->from_space;
        self->from_space += size + 1; // + 1 for header
        return tuple;
    }

    gc_copy(self);
    if (!gc_space_is_enough(self, size)) {
        gc_grow(self);
    }

    return gc_allocate_tuple(self, size);
}

static void
gc_copy(gc_t* self) {
    (void) self;
}

static void
gc_grow(gc_t* self) {
    (void) self;
}
