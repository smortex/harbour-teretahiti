#ifndef BUSPOSITION_H
#define BUSPOSITION_H

#include <QObject>

class BusPosition : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id)
    Q_PROPERTY(int busId READ busId)
    Q_PROPERTY(int lineId READ lineId)
    Q_PROPERTY(double lat READ lat)
    Q_PROPERTY(double lng READ lng)
    Q_PROPERTY(double odometer READ odometer)
    Q_PROPERTY(double speed READ speed)

    int m_id;
    int m_busId;
    int m_lineId;
    double m_lat;
    double m_lng;
    double m_odometer;
    double m_speed;

public:
    explicit BusPosition(QObject *parent = nullptr);
    BusPosition(QObject *parent, int id, int busId, int lineId, double lat, double lng, double odometer, double speed);

    int id() const;
    int busId() const;
    int lineId() const;
    double lat() const;
    double lng() const;
    double odometer() const;
    double speed() const;

};

#endif // BUSPOSITION_H
