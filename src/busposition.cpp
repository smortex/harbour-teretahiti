#include "busposition.h"

BusPosition::BusPosition(QObject *parent) : QObject(parent)
{

}

BusPosition::BusPosition(QObject *parent, int id, int busId, int lineId, double lat, double lng, double odometer, double speed) : QObject(parent)
{
    m_id = id;
    m_busId = busId;
    m_lineId = lineId;
    m_lat = lat;
    m_lng = lng;
    m_odometer = odometer;
    m_speed = speed;
}

int BusPosition::id() const
{
    return m_id;
}

int BusPosition::busId() const
{
    return m_busId;
}

int BusPosition::lineId() const
{
    return m_lineId;
}

double BusPosition::lat() const
{
    return m_lat;
}

double BusPosition::lng() const
{
    return m_lng;
}

double BusPosition::odometer() const
{
    return m_odometer;
}

double BusPosition::speed() const
{
    return m_speed;
}
