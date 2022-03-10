
#ifndef BITWARDEN_H
#define BITWARDEN_H

#include <QObject>
#include <QProcess>

#include <KWallet/KWallet>

using namespace KWallet;


class BitwardenVault : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(QString status READ status NOTIFY statusChanged);

    explicit BitwardenVault(QObject *parent = 0);
    ~BitwardenVault();

    QString status() const { return QString(mStatus); };
    QString sessionKey() const { return QString(*mSessionKey); };

    Q_INVOKABLE void loadVaultStatus();
    Q_INVOKABLE void unlock(QString password);

Q_SIGNALS:
    void statusChanged();
    void unlockFailed();

private slots:
    void readVaultStatus();
    void walletOpened(bool ok);

    void readUnlockResult(int exitCode, QProcess::ExitStatus status);

private:
    Wallet *mWallet;

    QString mStatus;
    QProcess *mProcess;
    QString *mSessionKey;

    QProcess *unlockProcess;

    void setVaultStatus(QString status);
    void loadKWallet();
};


#endif // BITWARDEN_H
