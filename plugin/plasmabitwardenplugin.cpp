
#include "plasmabitwardenplugin.h"

void PlasmaBitwardenPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(QLatin1String(uri) == QLatin1String("com.github.sleeuwen.plasmabitwarden"));
}
