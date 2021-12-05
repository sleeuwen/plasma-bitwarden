
#ifndef SECRETPROVIDER_H
#define SECRETPROVIDER_H

#include <QObject>
#include <QTimer>

#include <memory>

class KJob;

namespace Plasma
{
class DataEngineConsumer;
}

namespace PlasmaBitwarden
{

class SecretProvider : public QObject
{
    Q_OBJECT

public:
    explicit SecretProvider(const QString secret, QObject *parent);
    ~SecretProvider() override = default;

    Q_INVOKABLE void copyToClipboard();

private slots:
    void timerExpired();
    void onPlasmaServiceRemovePasswordResult(KJob *job);

private:
    static void clearClipboard();

    std::unique_ptr<Plasma::DataEngineConsumer> mEngineConsumer;

    QString mSecret;
    QTimer mTimer;
};

}

#endif // SECRETPROVIDER_H
