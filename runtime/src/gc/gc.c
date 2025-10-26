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

void
gc_expose_root_space(gc_t* self, void ***root_space_pointer, void ***root_pointer_pointer) {
    *root_space_pointer = self->root_space;
    *root_pointer_pointer = self->root_pointer;
}

size_t
gc_root_length(gc_t* self) {
    return self->root_pointer - self->root_space;
}

void
gc_push_root(gc_t* self, tuple_t *tuple) {
    assert(gc_root_length(self) < self->root_size);
    *self->root_pointer = tuple;
    self->root_pointer++;
}

tuple_t *
gc_pop_root(gc_t* self) {
    assert(gc_root_length(self) > 0);
    self->root_pointer--;
    return *self->root_pointer;
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
        tuple_t *tuple = self->free_pointer;
        self->free_pointer += size + 1; // + 1 for header
        return tuple;
    }

    gc_copy(self);
    if (!gc_space_is_enough(self, size)) {
        gc_grow(self);
    }

    return gc_allocate_tuple(self, size);
}

static tuple_t *
gc_copy_tuple(gc_t* self, tuple_t *tuple) {
    assert(self->from_space < tuple);
    assert(tuple < self->from_space + self->from_size);
    if (tuple_is_forward(tuple)) {
        return tuple_get_forward(tuple);
    }

    // TODO copy and forward
    return tuple;
}

static void
gc_copy(gc_t* self) {
    size_t root_length = self->root_pointer - self->root_space;
    for (size_t i = 0; i < root_length; i++) {
        tuple_t *tuple = self->root_space[i];
        self->root_space[i] = gc_copy_tuple(self, tuple);
    }

    // use to_space as queue to trace and copy.

    // swap from_space with to_space
}

static void
gc_grow(gc_t* self) {
    (void) self;
}
