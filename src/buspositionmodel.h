#ifndef BUSPOSITIONMODEL_H
#define BUSPOSITIONMODEL_H

#include "busposition.h"

#include <QAbstractListModel>
#include <QNetworkReply>

class BusPositionModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int lineId READ lineId WRITE setLineId NOTIFY lineIdChanged)
    Q_PROPERTY(int count READ count)
public:
    explicit BusPositionModel(QObject *parent = nullptr);

    enum EntryRoles {
        IdRole = Qt::UserRole,
        BusIdRole,
        LineIdRole,
        LatRole,
        LngRole,
        OdometerRole,
    };

    int rowCount(const QModelIndex&) const override { return mItems->length(); }
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    void appendItem(int id, int busId, int lineId, double lat, double lng, double odometer, double speed);

    Q_INVOKABLE void refresh();
    int count();
    Q_INVOKABLE BusPosition *get(int i);
    int lineId() const;
    void setLineId(int newLineId);

signals:
    void preItemAppended();
    void postItemAppended();

    void lineIdChanged();
    void refreshed();

public slots:
    void replyFinished(QNetworkReply *reply);

private:
    QList<BusPosition*>* mItems;

    int m_lineId;
};

#endif // BUSPOSITIONMODEL_H
