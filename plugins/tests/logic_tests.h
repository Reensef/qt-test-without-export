#include <QObject>
#include <QtTest/QTest>

#include <logic_plugin.h>

class LogicTests : public QObject
{
    Q_OBJECT

private Q_SLOTS:
    void initTestCase()
    {
        qDebug("Called before everything else.");
    }

    void multiply()
    {
        QFETCH(int, a);
        QFETCH(int, b);
        QFETCH(int, expected);

        LogicPlugin::LogicPlugin logic;

        QCOMPARE(logic.multiply(a, b), expected);
    }

    void multiply_data()
    {
        QTest::addColumn<int>("a");
        QTest::addColumn<int>("b");
        QTest::addColumn<int>("expected");

        QTest::newRow("left-zero") << 0 << 5 << 0;
        QTest::newRow("right-zero") << 5 << 0 << 0;
        QTest::newRow("both-zero") << 0 << 0 << 0;
        QTest::newRow("negative") << -5 << 10 << -50;
    }

    void cleanupTestCase()
    {
        qDebug("Called after myFirstTest and mySecondTest.");
    }
};

QTEST_GUILESS_MAIN(LogicTests);
