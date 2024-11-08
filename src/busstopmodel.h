#ifndef BUSSTOPMODEL_H
#define BUSSTOPMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QNetworkReply>
#include <QObject>

#include "busstop.h"

class BusStopModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit BusStopModel(QObject *parent = nullptr);

    enum EntryRoles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        LatitudeRole,
        LongitudeRole,
    };

    int rowCount(const QModelIndex&) const override { return mEntries->length(); }
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void update(QString data);
    Q_INVOKABLE void loadFromJson(QJsonObject data);

public slots:
    void replyFinished(QNetworkReply *reply);

private:
    QList<BusStop *>* mEntries;
    QString mCacheFilename;

    void loadFromCache();
};

#endif // BUSSTOPMODEL_H
