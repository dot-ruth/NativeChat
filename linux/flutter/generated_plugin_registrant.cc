//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <call_log_new/call_log_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) call_log_new_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CallLogPlugin");
  call_log_plugin_register_with_registrar(call_log_new_registrar);
}
