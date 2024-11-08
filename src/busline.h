#ifndef BUSLINE_H
#define BUSLINE_H

#include <QObject>

class BusLine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ getId)
    Q_PROPERTY(QString name READ getName)
    Q_PROPERTY(QString line_number READ getLineNumber)
    Q_PROPERTY(QString color READ getColor)
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

};

#endif // BUSLINE_H
