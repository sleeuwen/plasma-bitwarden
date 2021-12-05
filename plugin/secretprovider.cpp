
#include "secretprovider.h"

#include <QClipboard>
#include <QCryptographic>
#include <QGuiApplication>
#include <QMimeData>

#include <Plasma/DataEngine>
#include <Plasma/DataEngineConsumer>
#include <Plasma/Service>
#include <Plasma/ServiceJob>

const QString klipperDBusService = QStringLiteral("org.kde.klipper");
const QString klipperDBusPath = QStringLiteral("/klipper");
const QString klipperDataEngine = QStringLiteral("org.kde.plasma.clipboard");

using namespace PlasmaBitwarden;

SecretProvider::SecretProvider(const QString secret, QObject *parent)
    : QObject(parent)
    , mSecret(std::move(secret))
{
    mTimer.setInterval(45 * 1000);
    connect(&mTimer, SIGNAL(timeout()), this, SLOT(timerExpired()));
}

QMimeData *mimeDataForPassword(const QString &password)
{
    auto mimeData = new QMimeData;
    mimeData->setText(password);
    mimeData->setData(QStringLiteral("x-kde-passwordManagerHint"), "secret");
    return mimeData;
}

void SecretProvider::copyToClipboard()
{
    const auto clipboard = qGuiApp->clipboard();
    clipboard->setMimeData(mimeDataForPassword(mSecret), QClipboard::Clipboard);

    if (clipboard->supportsSelection()) {
        clipboard->setMimeData(mimeDataForPassword(mSecret), QClipboard::Selection);
    }

    mTimer.start();
}

void SecretProvider::timerExpired()
{
    mTimer.stop();

    const auto clipboard = qGuiApp->clipboard();
    if (clipboard->text() == mSecret) {
        clipboard->clear();
    }

    if (!mEngineConsumer) {
        mEngineConsumer = std::make_unique<Plasma::DataEngineConsumer>();
    }
    auto engine = mEngineConsumer->dataEngine(klipperDataEngine);

    const auto service = engine->serviceForSource(QString::fromLatin1(QCryptographicHash::hash(mSecret.toUtf8(), QCryptographicHash::Sha1).toBase64()));
    if (service == nullptr) {
        mEngineConsumer.reset();
        clearClipboard();
        return;
    }

    auto job = service->startOperationCall(service->operationDescription(QStringLiteral("remove")));

    connect(job, &KJob::result, this, &SecretProvider::onPlasmaServiceRemovePasswordResult);
}

void SecretProvider::onPlasmaServiceRemovePasswordResult(KJob *job)
{
    disconnect(job, &KJob::result, this, &SecretProvider::onPlasmaServiceRemovePasswordResult);
    QTimer::singleShot(0, this, [this]() {
        mEngineConsumer.reset();
    });

    auto serviceJob = qobject_cast<Plasma::ServiceJob *>(job);
    if (serviceJob->error() != 0) {
        clearClipboard();
        return;
    }

    if (!serviceJob->result().toBool()) {
        clearClipboard();
        return;
    }
}

void SecretProvider::clearClipboard()
{
    org::kde::klipper::klipper klipper(klipperDBusService, klipperDBusPath, QDBusConnection::sessionBus());
    if (!klipper.isValid()) {
        return;
    }

    klipper.clearClipboardHistory();
    klipper.clearClipboardContents();
}
