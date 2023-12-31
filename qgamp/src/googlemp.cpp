#include "googlemp.h"

#include <QNetworkAccessManager>
#include <QNetworkInterface>
#include <QNetworkReply>
#ifdef Q_OS_ANDROID
#include <QtAndroidExtras>
#include <QtAndroidExtras/QAndroidJniObject>
#endif
#include <QGuiApplication>
#include <QScreen>
#include <QSysInfo>
#include <QUrlQuery>
#include <QUuid>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>


#define GMP_MAXBUFFERSIZE 200

qint64 GoogleMP::m_startTime = 0;
QVariantMap GoogleMP::m_extParams;
QVariantMap GoogleMP::m_extSessionParams;
GoogleMP* GoogleMP::m_Instance = 0;

void GoogleMP::startSession(qint64 sTime, QVariantMap extSessionParams)
{
    m_startTime = sTime;
    m_extSessionParams = extSessionParams;
}

GoogleMP::GoogleMP(QObject *parent) : QObject(parent)
{
    m_appId = qApp->applicationName() + "." + qApp->organizationDomain();
    m_appVersion = qApp->applicationVersion();
    m_appName = qApp->applicationName();

    m_settings = new QSettings();
    QString uuid = m_settings->value("cid","").toString();
    if (uuid.isEmpty()) {
        // no CID yet
        uuid = QUuid::createUuid().toString();
        uuid.chop(1);
        uuid.remove(0,1);
        m_settings->setValue("cid", uuid);
    }
    m_uuid = m_settings->value("cid","").toString();

    qDebug() << "GoogleMP singleton initialized";
    qDebug() << m_uuid;

    m_enabled = isConnectedToNetwork();
#ifndef GMP_ID
    qWarning("GMP_ID missing from .pro file, GMP functionality disabled!");
    m_enabled = false;
    return;
#endif
    m_manager = new QNetworkAccessManager(this);

    QRect screenGeometry=QGuiApplication::primaryScreen()->geometry();
    m_width = screenGeometry.width();
    m_height = screenGeometry.height();
    m_ua = divineUserAgent();


    if (m_enabled) {
        qDebug() << "GoogleMP Analytics is a GO";
        QVariantMap top;
        top.insert( "sc", QString("start") );
        top.insert( "t", QString("screenview"));      // Screenview hit type.
        top.insert( "cd", QString("splash"));         // We will claim splash is the first screen
        if (m_startTime == 0) {
            m_startTime = QDateTime::currentMSecsSinceEpoch();
        } else { // if timing has already started, report time spent in waiting/queue
            top.insert( "qt", QString::number(QDateTime::currentMSecsSinceEpoch() - m_startTime));
        }
        foreach (QString key, m_extSessionParams.keys()) {
            top.insert(key, m_extSessionParams.value(key));
        }

        appendCommonData(&top);
        QByteArray postData = vmapToPostData(top);
        if (m_enabled) { // online logging
            sendRequest(postData);
            QStringList qsl = m_settings->value("reqbacklog", QStringList()).toStringList();
            if (qsl.size() > 1) {
                m_settings->setValue("reqbacklog", QStringList());
                foreach (QString postData, qsl) {
                    sendRequest(postData.toLatin1());
                }
                m_bufferfull = false;
                qDebug() << "Analytics backlog flushed";
                reportEvent("app", "OfflineEvents", QString::number(qsl.size()));
            }
        } else {
            QStringList qsl = m_settings->value("reqbacklog", QStringList()).toStringList();
            qsl.append(postData);
            m_settings->setValue("reqbacklog", qsl);
            qDebug() << "Net off, added to backlog";
        }
    }
}

QByteArray GoogleMP::vmapToPostData(QVariantMap top = QVariantMap()) {

    QUrlQuery urlQuery;
    //urlQuery.addQueryItem("v", "1");
    //urlQuery.addQueryItem("cid", m_uuid);
   // urlQuery.addQueryItem("tid", GMP_ID);
    //urlQuery.addQueryItem("measurement_id", "G-C276E1SDQ1");
    //urlQuery.addQueryItem("api_secret", "R67dWZ3QSWqH28oSrFzC1w");
    //urlQuery.addQueryItem("ds", "app");

    //foreach (const QString& key, top.keys()) {
     //   urlQuery.addQueryItem(key, top[key].toString());
   // }

    return urlQuery.query(QUrl::FullyEncoded).toLatin1();
}

void GoogleMP::sendRequest(QString screenName) {
    if (m_enabled) {
        QNetworkRequest req;

        QString scrName = screenName.simplified().replace(" ","_");

        //#ifdef QT_DEBUG
        //        req.setUrl(QUrl("https://www.google-analytics.com/debug/collect"));
        //#else
        //req.setUrl(QUrl("https://www.google-analytics.com/collect"));
        req.setUrl(QUrl("https://www.google-analytics.com/mp/collect?measurement_id=G-VL760C1JGW&api_secret=uqRb5XKPRAartF_jvuSTyg"));
        //#endif
        req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

        QJsonArray events;        QJsonObject subevent;
        subevent["name"] = scrName;
        events.push_back(subevent);

        QJsonObject objrequest;
        objrequest["user_id"] = m_ua;
        objrequest["client_id"] = m_uuid;
        //add the array to the object
        objrequest.insert("events", events);
        QJsonDocument doc(objrequest);
        QByteArray data = doc.toJson();


          //qDebug() << QString(postData);
           qDebug() << QString(data);
            qDebug() << QString(doc.toJson());

        if (m_manager != NULL)
            m_reply = m_manager->post(req, data);
           // m_reply = m_manager->post(req, postData);
        else
            qDebug() << "Uh-oh, no QNAManager!";


        QObject::connect(m_reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(networkreply()));
      // QObject::connect(m_reply, SIGNAL(finished()), this, SLOT(networkreply()));
    } else if (!m_bufferfull) {
        QStringList qsl = m_settings->value("reqbacklog", QStringList()).toStringList();
        qsl.append(screenName);
        m_settings->setValue("reqbacklog", qsl);
        qDebug() << QString("Net off, %0 added to backlog").arg(QString(screenName));
        if (qsl.size() > GMP_MAXBUFFERSIZE) m_bufferfull = true;
    }
}

void GoogleMP::appendCommonData(QVariantMap* base)
{

}

void GoogleMP::showScreen(QString screenName)
{
    qDebug() << "GoogleMP showScreen " << screenName;
    // "Report request for non-existent timer " + screenName + " asked";
   // QVariantMap top;


// top.insert( "t", QString("screenview"));      // Pageview hit type.
 //top.insert( "cd", QString(screenName));      // Pageview hit type.
   // top.insert("",QString(req));
   // appendCommonData(&top);
    sendRequest(screenName);
}

void GoogleMP::startTiming(QString eventName, bool overwrite = true)
{
    qDebug() << "startTiming " << eventName << overwrite;
    if (overwrite || !m_timers.contains(eventName)) {
        m_timers.remove(eventName);
        m_timers.insert(eventName, QDateTime().currentMSecsSinceEpoch());
    }
}

void GoogleMP::reportTiming(QString eventName, bool reset = true)
{
    qDebug() << "reportTiming " << eventName << reset;
    if (m_timers.contains(eventName) || eventName.startsWith("startup")) {
        qint64 elapsed = QDateTime::currentMSecsSinceEpoch();
        if (!eventName.startsWith("startup"))
            elapsed -= m_timers.value(eventName);               // Timing
        else
            elapsed -= m_startTime;               // Timing

        reportRawTiming(eventName, elapsed);               // Timing
        qDebug() << "Timing " << eventName;
    } else {
        qDebug() << "Report request for non-existent timer " + eventName + " asked";
    }

    if (reset)
        m_timers.remove(eventName);

}

void GoogleMP::reportRawTiming(QString eventName, int msecs)
{
    QVariantMap top;
    top.insert( "t", QString("timing"));      // Pageview hit type.
    top.insert( "utc", eventName);            // Category.
    top.insert( "utv", eventName);            // Variable.
    top.insert( "utl", eventName);            // Label.
    top.insert( "utt", msecs);
    appendCommonData(&top);
    sendRequest(eventName);
}

void GoogleMP::reportEvent(QString category, QString action, QString value = "")
{
    qDebug() << "GoogleMP reportEvent " << category << " " << action << " " << value;
    QVariantMap top;

    top.insert( "t", QString("event"));      // Event hit type.
    top.insert( "ec", category);             // Category.
    top.insert( "ea", action);               // Action.
    top.insert( "el", action);               // Label.
    if (!value.isEmpty())
        top.insert( "ev", value);            // Value.

    appendCommonData(&top);

    qDebug() << "GoogleMP reportEvent";
    sendRequest(action);
}

void GoogleMP::sendRaw(QString rawstring)
{
    qDebug() << "GoogleMP sendRaw";

    if (!rawstring.contains("&t="))
        qDebug() << "Warning - sendRaw without GMP type specified!";

    sendRequest(rawstring);
}

GoogleMP::~GoogleMP()
{

}

void GoogleMP::networkreply()
{
    qDebug() << "GoogleMP networkreply";
    if (m_reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt() != 200) {
        qDebug() << m_reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
//        qDebug() << m_reply->isFinished();
        qDebug() << m_reply->error() << m_reply->errorString();
        qDebug() << m_reply->request().url();
        qDebug() << m_reply->readAll();
        qDebug() << "Nuff said";
    }
}


QString GoogleMP::divineUserAgent()
{
    QString ua="";
#ifdef Q_OS_ANDROID
    QAndroidJniObject qaj= QAndroidJniObject::callStaticObjectMethod("java/lang/System", "getProperty", "(Ljava/lang/String;)Ljava/lang/String;", QAndroidJniObject::fromString("http.agent").object());
    ua = qaj.toString();
    if (ua.isEmpty()) {
        ua = QString("Mozilla/5.0 (Linux; Android %0; %1 Build/%2) Qt/%3")
                                           .arg(QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build$VERSION", "RELEASE").toString())
                                           .arg(QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build", "MODEL").toString())
                                           .arg(QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build", "DISPLAY").toString())
                                           .arg(qVersion());
    }

    /* extra potential info from anroid/os/Build
        qDebug() << QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build", "MANUFACTURER").toString(); // LGE
        qDebug() << QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build", "MODEL").toString();        // Nexus 5
        qDebug() << QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build", "PRODUCT").toString();      // hammerhead
        qDebug() << QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build", "HARDWARE").toString();     // hammerhead
        qDebug() << QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build", "DEVICE").toString();       // hammerhead
        qDebug() << QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build", "CPU_ABI").toString();      // armeabi-v7a
        qDebug() << QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build", "BRAND").toString();        // google
        qDebug() << QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build", "SERIAL").toString();       // 02e05272...
        qDebug() << QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build", "DISPLAY").toString();      // KOT49H
        qDebug() << QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build", "BOARD").toString();        // hammerhead
        qDebug() << QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build", "TAGS").toString();         // release-keys
        qDebug() << QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build$VERSION", "RELEASE").toString(); // 4.4.2
        qDebug() << QAndroidJniObject::getStaticObjectField<jstring>("android/os/Build$VERSION", "INCREMENTAL").toString(); // 937116
        qDebug() << QString::number(QAndroidJniObject::getStaticField<jint>("android/os/Build$VERSION", "SDK_INT"));    // 19

    **/

#elif defined(Q_OS_IOS)
    ua = QString("Mozilla/5.0 (iPhone; U; CPU iPhone OS %0 like Mac OS X; en)").arg(QSysInfo::productVersion().replace('.',"_"));
//    Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25
#elif defined(Q_OS_LINUX)
    ua = QString("Mozilla/5.0 (X11; %0; Linux %1) Qt/%2").arg(QSysInfo::productType(), QSysInfo::currentCpuArchitecture(), qVersion());
//    ua = QString("Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:24.0) Gecko/20100101 Firefox/24.0");
//#elif defined(Q_OS_WIN)
//    ua = QString("Mozilla/5.0 (Windows %0) Qt/%1").arg(QSysInfo::productType(), qVersion());
//    ua = QString("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36");
#else
    // ... TODO Implement meaningful User-Agent strings for real platforms
    qDebug() << QSysInfo::prettyProductName();
    qDebug() << QSysInfo::productType();
    qDebug() << QSysInfo::productVersion();
    qDebug() << QSysInfo::kernelType();
    qDebug() << QSysInfo::kernelVersion();
    qDebug() << QSysInfo::currentCpuArchitecture();
#endif

    return ua;
}

bool GoogleMP::isConnectedToNetwork(){

    QList<QNetworkInterface> ifaces = QNetworkInterface::allInterfaces();
    bool result = false;

    for (int i = 0; i < ifaces.count(); i++) {

        QNetworkInterface iface = ifaces.at(i);
        if ( iface.flags().testFlag(QNetworkInterface::IsUp)
             && !iface.flags().testFlag(QNetworkInterface::IsLoopBack)) {

#ifdef QT_DEBUG
            // details of connection
            qDebug() << "name:" << iface.name() << Qt::endl
                     << "ip addresses:" << Qt::endl
                     << "mac:" << iface.hardwareAddress() << Qt::endl;
#endif


            for (int j=0; j<iface.addressEntries().count(); j++) {
#ifdef QT_DEBUG
                qDebug() << iface.addressEntries().at(j).ip().toString()
                         << " / " << iface.addressEntries().at(j).netmask().toString() << Qt::endl;
#endif

                // got an interface which is up, and has an ip address
                if (result == false)
                    result = true;
            }
        }

    }

    return result;
}
