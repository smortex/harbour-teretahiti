#ifndef BUSLINE_H
#define BUSLINE_H

#include <QObject>

class BusLine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ getId NOTIFY changed)
    Q_PROPERTY(QString name READ getName NOTIFY changed)
    Q_PROPERTY(QString line_number READ getLineNumber NOTIFY changed)
    Q_PROPERTY(QString color READ getColor NOTIFY changed)
public:
    explicit BusLine(QObject *parent = nullptr);
    BusLine(QObject *parent, int id, QString line_number, QString name, QString color);

    int getId() const;
    QString getName() const;
    QString getLineNumber() const;
    QString getColor() const;

private:
    int mId;
    QString mName;
    QString mLineNumber;
    QString mColor;

signals:
    void changed();

};

#endif // BUSLINE_H
