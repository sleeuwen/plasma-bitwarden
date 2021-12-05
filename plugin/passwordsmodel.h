

#ifndef PASSWORDSMODEL_H_
#define PASSWORDSMODEL_H_

#include <QAbstractItemModel>
#include <QProcess>

namespace PlasmaBitwarden
{

class PasswordsModel : public QAbstractItemModel
{
    Q_OBJECT

    struct Node;

public:

    enum Roles {
        NameRole = Qt::DisplayRole,
        IdRole,
        UsernameRole,
        FilterRole,
    };

    explicit PasswordsModel(QObject *parent = nullptr);
    ~PasswordsModel() override;

    QHash<int, QByteArray> roleNames() const override;

    int rowCount(const QModelIndex & parent) const override;
    int columnCount(const QModelIndex & parent) const override;

    QModelIndex index(int row, int column, const QModelIndex & parent) const override;
    QModelIndex parent(const QModelIndex & child) const override;

    QVariant data(const QModelIndex & index, int role) const override;

    Q_INVOKABLE void copyToClipboard(QString id) const;

private slots:
    void readData();

private:
    QProcess *process;

    void populate();

    static Node *node(const QModelIndex &index);

    std::vector<Node*> mNodes;
};

}

#endif // PASSWORDSMODEL_H_
