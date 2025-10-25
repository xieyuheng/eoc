#include "index.h"

void
test_gc(void) {
    test_start();

    gc_initialize(1024, 1024);

    test_end();
}
