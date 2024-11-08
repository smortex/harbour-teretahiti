#ifndef BUSLINEMODEL_H
#define BUSLINEMODEL_H

#include <QAbstractListModel>

#include "busline.h"

class BusLineModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit BusLineModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex&) const override { return mEntries->length(); }
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void update(QString data);

    enum EntryRoles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        LineNumberRole,
        ColorRole,
    };

private:
    QList<BusLine*>* mEntries;
    QString mCacheFilename;

    void loadFromCache();
};

#endif // BUSLINEMODEL_H
