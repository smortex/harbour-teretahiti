#include "busstop.h"

BusStop::BusStop(QObject *parent) : QObject(parent)
{

}

BusStop::BusStop(QObject *parent, int id, QString name, double latitude, double longitude) : QObject(parent)
{
    mId = id;
    mName = name;
    mLatitude = latitude;
    mLongitude = longitude;
}

int BusStop::getId() const
{
    return mId;
}

QString BusStop::getName() const
{
    return mName;
}

double BusStop::getLatitude() const
{
    return mLatitude;
}

double BusStop::getLongitude() const
{
    return mLongitude;
}
