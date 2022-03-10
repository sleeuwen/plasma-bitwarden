
#include "bitwardenvault.h"

#include <QProcess>
#include <QJsonDocument>
#include <QJsonObject>
#include <QGuiApplication>
#include <string>
#include <iostream>



BitwardenVault::BitwardenVault(QObject *parent)
    : QObject(parent)
{
    setVaultStatus("loading");
}

BitwardenVault::~BitwardenVault() = default;


void BitwardenVault::loadVaultStatus()
{
    QStringList args = { "--nointeraction", "status" };

    if (mSessionKey != 0) {
        args << "--session" << *mSessionKey;
    }

    mProcess = new QProcess(this);
    connect(mProcess, SIGNAL(readyReadStandardOutput()), this, SLOT(readVaultStatus()));
    mProcess->start("bw", args);
}

void BitwardenVault::readVaultStatus()
{
    auto output = mProcess->readAllStandardOutput();
    auto jsonDoc = QJsonDocument::fromJson(output);
    mProcess = nullptr;
    auto jsonObj = jsonDoc.object();
    auto status = jsonObj["status"].toString();

    if (status == "locked") {
        if (mWallet == nullptr) {
            loadKWallet();
        } else {
            setVaultStatus("locked");
        }
    } else if (status == "unlocked") {
        setVaultStatus("unlocked");
    }
}

void BitwardenVault::unlock(QString password)
{
    QStringList args = { "--nointeraction", "unlock", password, "--raw" };

    unlockProcess = new QProcess(this);
    connect(unlockProcess, SIGNAL(finished(int, QProcess::ExitStatus)), this, SLOT(readUnlockResult(int, QProcess::ExitStatus)));
    unlockProcess->start("bw", args);
}

void BitwardenVault::readUnlockResult(int exitCode, QProcess::ExitStatus status)
{
    if (exitCode != 0) {
        Q_EMIT(unlockFailed());
        return;
    }

    auto output = unlockProcess->readAllStandardOutput();
    auto outputString = new QString(output);
    mSessionKey = outputString;

    if (!mWallet->hasFolder("plasmabitwarden")) {
        mWallet->createFolder("plasmabitwarden");
    }
    mWallet->setFolder("plasmabitwarden");

    if (mWallet->hasEntry(QStringLiteral("com.github.sleeuwen.plasmabitwarde/session_key"))) {
        mWallet->removeEntry(QStringLiteral("com.github.sleeuwen.plasmabitwarde/session_key"));
    }

    mWallet->writePassword(QStringLiteral("com.github.sleeuwen.plasmabitwarde/session_key"), *mSessionKey);

    setVaultStatus("loading");
    loadVaultStatus();
}

void BitwardenVault::loadKWallet()
{
    mWallet = Wallet::openWallet(Wallet::LocalWallet(), 0, Wallet::Asynchronous);
    connect(mWallet, SIGNAL(walletOpened(bool)), this, SLOT(walletOpened(bool)));
}

void BitwardenVault::walletOpened(bool ok)
{
    if (!ok) {
        setVaultStatus("locked");
    } else {
        if (!mWallet->hasFolder("plasmabitwarden")) {
            mWallet->createFolder("plasmabitwarden");
        }
        mWallet->setFolder("plasmabitwarden");

        QString value;
        auto res = mWallet->readPassword(QStringLiteral("com.github.sleeuwen.plasmabitwarden/session_key"), value);
        if (res == 0) {
            mSessionKey = &value;

            loadVaultStatus();
        }
    }
}

void BitwardenVault::setVaultStatus(QString status)
{
    mStatus = status;
    Q_EMIT(statusChanged());
}
