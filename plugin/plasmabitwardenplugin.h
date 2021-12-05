#ifndef PLASMABITWARDENPLUGIN_H
#define PLASMABITWARDENPLUGIN_H

#include <QQmlExtensionPlugin>

class PlasmaBitwardenPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri) override;
};

#endif // PLASMABITWARDENPLUGIN_H
