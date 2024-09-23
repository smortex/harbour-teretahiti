#ifndef BUSSTOP_H
#define BUSSTOP_H

#include <QObject>

class BusStop : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ getId NOTIFY changed)
    Q_PROPERTY(QString name READ getName NOTIFY changed)
    Q_PROPERTY(double latitude READ getLatitude NOTIFY changed)
    Q_PROPERTY(double longitude READ getLongitude NOTIFY changed)

public:
    explicit BusStop(QObject *parent = nullptr);
    BusStop(QObject *parent, int id, QString name, double latitude, double longitude);

    int getId() const;
    QString getName() const;
    double getLatitude() const;
    double getLongitude() const;

private:
    int mId;
    QString mName;
    double mLatitude;
    double mLongitude;

signals:
    void changed();
};

#endif // BUSSTOP_H
