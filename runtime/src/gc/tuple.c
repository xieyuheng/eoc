#include "index.h"

typedef void *header_t;

/* header format (64 bits):

   | unused | pointer mask | size   | forward |
   | 7 bits | 50 bits      | 6 bits | 1 bit   |

*/

void
tuple_init(tuple_t *self, size_t size) {
    assert(size <= 50);
    uint64_t forward_bit = 1;
    uint64_t size_bits = size << 1;
    header_t header = (header_t) (size_bits | forward_bit);
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
    uint64_t low_byte = ((uint64_t) header) & ((uint64_t) 0xff);
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
tuple_set_atom(tuple_t *self, size_t index, int64_t atom) {
    header_t header = self[0];
    uint64_t pointer_mask = ~(1 << (index + 7));
    self[0] = (header_t) ((uint64_t) header & pointer_mask);
    self[index + 1] = (void *) atom;
}
