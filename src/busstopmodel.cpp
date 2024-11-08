#include "busstopmodel.h"

#include <QDebug>
#include <QDir>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QStandardPaths>
#include <QNetworkAccessManager>
#include <QUrl>
#include <QNetworkRequest>

BusStopModel::BusStopModel(QObject *parent) : QAbstractListModel(parent)
{
    mEntries = new QList<BusStop*>();

    mCacheFilename = QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + QDir::separator() + "stops.json";
    if (QFile::exists(mCacheFilename)) {
        qDebug() << "Using existing stops cache file";
        loadFromCache();

    } else {
        qDebug() << "No cached data for stops";
        QNetworkAccessManager *manager = new QNetworkAccessManager(this);
        connect(manager, SIGNAL(finished(QNetworkReply*)),
                this, SLOT(replyFinished(QNetworkReply*)));

        manager->get(QNetworkRequest(QUrl("http://locbusrtct.dataccessor.com:20082/api/places/all")));
    }
}

QVariant BusStopModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    switch (role) {
    case IdRole:
        return mEntries->at(index.row())->getId();
        break;
    case NameRole:
        return mEntries->at(index.row())->getName();
        break;
    case LatitudeRole:
        return mEntries->at(index.row())->getLatitude();
        break;
    case LongitudeRole:
        return mEntries->at(index.row())->getLongitude();
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> BusStopModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[NameRole] = "name";
    roles[LatitudeRole] = "latitude";
    roles[LongitudeRole] = "longitude";
    return roles;
}

void BusStopModel::update(QString data)
{
    QFile file(mCacheFilename);
    if (file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        QTextStream stream(&file);
        stream << data << endl;
    }

    loadFromCache();
}

void BusStopModel::loadFromJson(QJsonObject data)
{
    QJsonArray jsonLines = data["data"].toArray();

    for (auto i = jsonLines.begin(), end = jsonLines.end(); i != end; i++) {
        auto o = i->toObject();

        int id = o["id"].toString().toInt();
        QString name = o["nom"].toString();
        double latitude = o["latitude"].toString().toDouble();
        double longitude = o["longitude"].toString().toDouble();

        mEntries->append(new BusStop(this, id, name, latitude, longitude));
    }
}

void BusStopModel::replyFinished(QNetworkReply *reply)
{
    update(reply->readAll());
}

void BusStopModel::loadFromCache()
{
    beginResetModel();
    mEntries->clear();

    QFile file(mCacheFilename);
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        loadFromJson(doc.object());

    }
    endResetModel();
}
