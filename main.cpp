#include <QDateTime>
#include <QDebug>
#include <QGuiApplication>
#include <QLocale>
#include <QQmlApplicationEngine>
#include <QTranslator>

#include "qgamp/src/googlemp.h"


// define the singleton type provider function (callback).
static QObject* analytics_singletontype_provider(QQmlEngine* engine, QJSEngine* scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    qDebug() << "Creating/getting GoogleMP singleton";
    GoogleMP* gmp = GoogleMP::instance();
    return gmp;
}


int main(int argc, char *argv[])
{
    //add GA4 config
    //GA4 ga4("G-C276E1SDQ1");

   // ga4.sendEvent("debugTester",{"ga4 is live", "happy go"});
    qint64 imAlive = QDateTime::currentMSecsSinceEpoch();

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/util/IconType.qml")), "Parlance", 1, 0, "IconType");

    QGuiApplication app(argc, argv);

    // QApplication level app name and version are used automatically in Google Analytics
    qApp->setApplicationName("Parlance");
    qApp->setApplicationVersion(APPLICATION_VERSION);
    qApp->setOrganizationDomain("ola.org");
    qApp->setOrganizationName("Legislative Assembly of Ontario");

    // start session
    GoogleMP::startSession(imAlive);



    // register qgamp to be available to QML apps
    qmlRegisterSingletonType<GoogleMP>("MeasurementProtocol", 1, 0, "Analytics", analytics_singletontype_provider);

    // load the translation file based on system locale.
    QTranslator translator;
    if (translator.load(QLocale(), QLatin1String("parlance"), QLatin1String("_"), QLatin1String(":/")))
    {
        app.installTranslator(&translator);
    }

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
