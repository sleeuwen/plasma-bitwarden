
#include "passwordsmodel.h"

#include <QGuiApplication>
#include <QClipboard>
#include <QMimeData>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>
#include <QProcess>
#include <string>
#include <iostream>

using namespace PlasmaBitwarden;

struct PasswordsModel::Node {
    explicit Node() = default;
    Node(QString id, QString name, QString url, QString username, QString password)
        : id(std::move(id))
        , name(std::move(name))
        , url(std::move(url))
        , username(std::move(username))
        , password(std::move(password))
    {
        setFilterText();
    }

    Node(const Node &other) = delete;
    Node(Node &&other) = default;
    Node &operator=(const Node &other) = delete;
    Node &operator=(Node &&other) = delete;

    ~Node() = default;

    void setFilterText() {
        filterText = name + "|" + url + "|" + username;
    }

    QString id;
    QString name;
    QString url;
    QString username;
    QString password;
    QString filterText;
};

PasswordsModel::PasswordsModel(QObject *parent)
    : QAbstractItemModel(parent)
{
    // TODO: Set status to loading
    populate();
}

PasswordsModel::~PasswordsModel() = default;

QHash<int, QByteArray> PasswordsModel::roleNames() const
{
    return {{NameRole, "name"},
            {IdRole, "id"},
            {UsernameRole, "username"},
            {FilterRole, "filterText"},
            };
}

int PasswordsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mNodes.size();
}

int PasswordsModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return 1;
}

QModelIndex PasswordsModel::index(int row, int column, const QModelIndex &parent) const
{
    if (row < 0 || row > mNodes.size() || column != 0) {
        return {};
    }

    return createIndex(row, column, mNodes[row]);
}

QModelIndex PasswordsModel::parent(const QModelIndex &child) const
{
    return {};
}

QVariant PasswordsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return {};

    const auto node = mNodes[index.row()];

    switch (role) {
    case Qt::DisplayRole:
        return node->name;
    case IdRole:
        return node->id;
    case UsernameRole:
        return node->username;
    case FilterRole:
        return node->filterText;
    default:
        return {};
    }
}

QMimeData *mimeDataForPassword(const QString &password)
{
    auto mimeData = new QMimeData;
    mimeData->setText(password);
    mimeData->setData(QStringLiteral("x-kde-passwordManagerHint"), "secret");
    return mimeData;
}

void PasswordsModel::copyToClipboard(QString id) const
{
    Node *node = 0;
    for (auto i = 0; i < mNodes.size(); i++) {
        if (mNodes[i]->id == id) {
            node = mNodes[i];
            break;
        }
    }

    if (node == 0)  {
        return;
    }

    std::cout << node->name.toStdString() << std::endl;

    const auto clipboard = qGuiApp->clipboard();
    clipboard->setMimeData(mimeDataForPassword(node->password), QClipboard::Clipboard);

    if (clipboard->supportsSelection()) {
        clipboard->setMimeData(mimeDataForPassword(node->password), QClipboard::Selection);
    }
}

void PasswordsModel::populate()
{
    std::cout << "populate" << std::endl;
    if (this->vault == 0) {
        std::cout << "null" << std::endl;
        return;
    }

    std::cout << "not null" << std::endl;
    QString sessionKey = this->vault->sessionKey();
    std::cout << "session key " << sessionKey.toStdString() << std::endl;
    process = new QProcess();
    QStringList args = { "list", "items", "--nointeraction", "--session", sessionKey };

    connect(process, SIGNAL(readyReadStandardOutput()), this, SLOT(readData()));
    process->start("bw", args);
}

void PasswordsModel::readData() {
    if (process->exitCode() != 0) {
        std::cout << "Invalid exit code from process" << std::endl;
        return; // TODO: Error
    }

    auto output = process->readAllStandardOutput();
    auto json_doc = QJsonDocument::fromJson(output);
    process = nullptr;
    if (!json_doc.isArray()) {
        std::cout << "Invalid json document returned from process" << std::endl;
        return; // TODO: Error
    }

    beginResetModel();
    mNodes.clear();

    auto json_list = json_doc.array();
    for (auto i = 0; i < json_list.size(); i++) {
        auto item = json_list[i].toObject();

        if (!item.contains("login")) {
            continue;
        }

        auto login = item["login"].toObject();

        QString uri;
        if (login.contains("uris") && login["uris"].toArray().size() > 0) {
            uri = login["uris"].toArray()[0].toObject()["uri"].toString();
        }

        auto node = new Node(item["id"].toString(), item["name"].toString(), uri, login["username"].toString(), login["password"].toString());
        mNodes.push_back(node);
    }

    endResetModel();
}

void PasswordsModel::setVault(BitwardenVault* vault)
{
    std::cout << "setVault " << (vault == 0 ? "null" : "not null") << std::endl;
    this->vault = vault;
    mNodes.clear();
    this->populate();
}
