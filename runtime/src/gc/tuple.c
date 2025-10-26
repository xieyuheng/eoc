#include "index.h"

typedef void *header_t;

/* header format (64 bits):

   | unused | pointer mask | size   | is forward |
   | 7 bits | 50 bits      | 6 bits | 1 bit      |

*/

void
tuple_init(tuple_t *self, size_t size) {
    assert(size <= 50);
    header_t header = (header_t) (size << 1);
    self[0] = header;
}

tuple_t *
tuple_new(size_t size, gc_t *gc) {
    tuple_t *self = gc_allocate_tuple(gc, size);
    tuple_init(self, size);
    return self;
}

size_t
tuple_size(tuple_t *self) {
    header_t header = self[0];
    uint64_t low_byte = ((uint64_t) header) & ((uint64_t) 0b01111111);
    return low_byte >> 1;
}

bool
tuple_is_atom_index(tuple_t *self, size_t index) {
    assert(index < tuple_size(self));
    header_t header = self[0];
    uint64_t pointer_mask = ((uint64_t) header) >> (index + 7);
    return (pointer_mask & 1) == 0;
}

bool
tuple_is_object_index(tuple_t *self, size_t index) {
    assert(index < tuple_size(self));
    header_t header = self[0];
    uint64_t pointer_mask = ((uint64_t) header) >> (index + 7);
    return (pointer_mask & 1) == 1;
}

void
tuple_set_object(tuple_t *self, size_t index, void *object) {
    header_t header = self[0];
    uint64_t pointer_mask = 1 << (index + 7);
    self[0] = (header_t) ((uint64_t) header | pointer_mask);
    self[index + 1] = object;
}

void
tuple_set_atom(tuple_t *self, size_t index, uint64_t atom) {
    header_t header = self[0];
    uint64_t pointer_mask = ~(1 << (index + 7));
    self[0] = (header_t) ((uint64_t) header & pointer_mask);
    self[index + 1] = (void *) atom;
}

void *
tuple_get_object(tuple_t *self, size_t index) {
    tuple_is_object_index(self, index);
    return self[index + 1];
}

uint64_t
tuple_get_atom(tuple_t *self, size_t index) {
    tuple_is_atom_index(self, index);
    return (uint64_t) self[index + 1];
}

bool
tuple_is_forward(tuple_t *self) {
    header_t header = self[0];
    return ((uint64_t) header & 1) == 1;
}

tuple_t *
tuple_get_forward(tuple_t *self) {
    assert(tuple_is_forward(self));
    return self[1];
}

void
tuple_set_forward(tuple_t *self, tuple_t *tuple) {
    assert(!tuple_is_forward(self));
    header_t header = self[0];
    self[0] = (header_t) ((uint64_t) header | 1);
    self[1] = tuple;
}

void
tuple_print(tuple_t *self, file_t *file) {
    if (tuple_is_forward(self)) {
        fprintf(file, "*");
        tuple_print(tuple_get_forward(self), file);
        return;
    }

    fprintf(file, "[");
    for (size_t i = 0; i < tuple_size(self); i++) {
        if (tuple_is_atom_index(self, i)) {
            fprintf(file, "%ld", tuple_get_atom(self, i));
        } else {
            tuple_print(tuple_get_object(self, i), file);
        }

        if (i != tuple_size(self) - 1) {
            fprintf(file, " ");
        }
    }
    fprintf(file, "]");
}
