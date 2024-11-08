#include "busline.h"

BusLine::BusLine(QObject *parent) : QObject(parent)
{

}

BusLine::BusLine(QObject *parent, int id, QString line_number, QString name, QString color) : QObject(parent) {
    mId = id;
    mLineNumber = line_number;
    mName = name;
    mColor = color;
}

int BusLine::getId() const {
    return mId;
}

QString BusLine::getName() const {
    return mName;
}

QString BusLine::getLineNumber() const {
    return mLineNumber;
}

QString BusLine::getColor() const {
    return mColor;
}
