#include "buslinemodel.h"

#include <QDebug>
#include <QDir>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValueRef>
#include <QStandardPaths>

BusLineModel::BusLineModel(QObject *parent)
    : QAbstractListModel(parent)
{
    mEntries = new QList<BusLine*> ();
    mCacheFilename = QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + QDir::separator() + "lines.json";


    if (QFile::exists(mCacheFilename)) {
        qDebug() << "Using existing lines cache file";
        loadFromCache();

    } else {
        qDebug() << "No cached data for lines";
    }
}

void BusLineModel::update(QString data)
{
    QFile file(mCacheFilename);
    if (file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        QTextStream stream(&file);
        stream << data << endl;
    }

    loadFromCache();
}

void BusLineModel::loadFromCache()
{
    beginResetModel();
    mEntries->clear();

    QFile file(mCacheFilename);
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        QJsonArray jsonLines = doc.object()["data"].toArray();

        for (auto i = jsonLines.begin(), end = jsonLines.end(); i != end; i++) {
            auto o = i->toObject();

            int id = o["id"].toString().toInt();
            QString line_number = o["numCom"].toString();
            QString name = o["name"].toString();
            QString color = o["color"].toString();

            mEntries->append(new BusLine(this, id, line_number, name, color));
        }

    }
    endResetModel();
}

QVariant BusLineModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    switch (role) {
    case IdRole:
        return mEntries->at(index.row())->getId();
        break;
    case LineNumberRole:
        return mEntries->at(index.row())->getLineNumber();
        break;
    case NameRole:
        return mEntries->at(index.row())->getName();
        break;
    case ColorRole:
        return mEntries->at(index.row())->getColor();
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> BusLineModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[LineNumberRole] = "line_number";
    roles[NameRole] = "name";
    roles[ColorRole] = "color";
    return roles;
}
