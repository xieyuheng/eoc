#include "deps.h"
#include "config.h"
#include "commands/index.h"

int
main(int argc, char *argv[]) {
    file_disable_buffer(stdout);
    file_disable_buffer(stderr);

    commander_t *commander = commander_new("app", APP_VERSION, argc, argv);

    commander_use(commander, cmd_test_self);
    commander_use(commander, cmd_test_packages);
    commander_use(commander, cmd_default_version);
    commander_use(commander, cmd_default_help);

    return commander_run(commander);
}
