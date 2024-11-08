#include "buspositionmodel.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QUrl>

BusPositionModel::BusPositionModel(QObject *parent) : QAbstractListModel(parent)
{
    mItems = new QList<BusPosition *>();

    refresh();
}

QVariant BusPositionModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    switch (role) {
    case IdRole:
        return mItems->at(index.row())->id();
        break;
    case BusIdRole:
        return mItems->at(index.row())->busId();
        break;
    case LineIdRole:
        return mItems->at(index.row())->lineId();
        break;
    case LatRole:
        return mItems->at(index.row())->lat();
        break;
    case LngRole:
        return mItems->at(index.row())->lng();
        break;
    case OdometerRole:
        return mItems->at(index.row())->odometer();
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> BusPositionModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[BusIdRole] = "bus_id";
    roles[LineIdRole] = "line_id";
    roles[LatRole] = "lat";
    roles[LngRole] = "lng";
    roles[OdometerRole] = "odometer";
    return roles;
}

void BusPositionModel::appendItem(int id, int busId, int lineId, double lat, double lng, double odometer, double speed)
{
    emit preItemAppended();

    BusPosition *item = new BusPosition(this, id, busId, lineId, lat, lng, odometer, speed);

    mItems->append(item);

    emit postItemAppended();

}

void BusPositionModel::refresh()
{
    qDebug() << "Refreshing bus postion for lineId" << lineId();

    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    connect(manager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(replyFinished(QNetworkReply*)));

    manager->get(QNetworkRequest(QUrl(QString("http://locbusrtct.dataccessor.com:20082/api/bus/logs-course/%1").arg(lineId()))));
}

int BusPositionModel::count()
{
    return mItems->size();
}

BusPosition *BusPositionModel::get(int i)
{
    return mItems->at(i);
}

void BusPositionModel::replyFinished(QNetworkReply *reply)
{
    QString reply_json = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(reply_json.toUtf8());
    QJsonObject data = doc.object();
    QJsonArray positions = data.find("data")->toArray();

    qDebug().noquote() << doc.toJson(QJsonDocument::Indented);

    beginResetModel();
    mItems->clear();

    for (auto it = positions.begin(); it != positions.end(); ++it) {
        QJsonObject bus = it->toObject();

        int id = bus.find("id")->toString().toInt();
        int busId = bus.find("busId")->toString().toInt();
        int lineId = bus.find("lineId")->toString().toInt();
        double lat = bus.find("position")->toObject().find("lat")->toDouble();
        double lng = bus.find("position")->toObject().find("lng")->toDouble();
        double odometer = bus.find("odometer")->toString().toDouble();
        double speed = bus.find("speed")->toString().toDouble();

        // Sometime, we have no valid position
        if (lat != 0.0 && lng != 0) {
            appendItem(id, busId, lineId, lat, lng, odometer, speed);
        }
    }

    endResetModel();

    emit refreshed();
}

int BusPositionModel::lineId() const
{
    return m_lineId;
}

void BusPositionModel::setLineId(int newLineId)
{
    if (m_lineId == newLineId)
        return;
    m_lineId = newLineId;
    emit lineIdChanged();

    refresh();
}
