
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

    QString status() const { return mStatus; };

    Q_INVOKABLE void loadVaultStatus();

Q_SIGNALS:
    void statusChanged();

private slots:
    void readVaultStatus();
    void walletOpened(bool ok);
    //void vaultStatusFinished(int exitCode, QProcess::ExitStatus exitStatus);

private:
    Wallet *mWallet;

    QString mStatus;
    QProcess *mProcess;
    QString *mSessionKey;

    void setVaultStatus(QString status);
    void loadKWallet();
};


#endif // BITWARDEN_H
