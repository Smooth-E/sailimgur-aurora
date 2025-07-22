#include <auroraapp.h>
#include <QtQuick/QtQuick>
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QtQml>
#include <QDebug>
#include <QTranslator>

#include "src/imageuploader.h"
#include "src/sailimgur.h"
#include "src/simplecrypt.h"

#define CLIENT_ID "44f3bd95ad7db12"
#define CLIENT_SECRET "AwLij1UYyeMhkq3xUEvNu3DH9/1YEMbtcZb3pQ5GwLB5yviiARnO5X3N+6VS"

/**
 * Clears the web cache, because Qt 5.2 WebView chokes on caches from older Qt versions.
 */
void clearWebCache() {
    const QStringList cachePaths = QStandardPaths::standardLocations(
                QStandardPaths::CacheLocation);

    if (cachePaths.size()) {
        // some very old versions of SailfishOS may not find this cache,
        // but that's OK since they don't have the web cache bug anyway
        const QString webCache = QDir(cachePaths.at(0)).filePath(".QtWebKit");
        QDir cacheDir(webCache);
        if (cacheDir.exists()) {
            if (cacheDir.removeRecursively()) {
                qDebug() << "Cleared web cache:" << webCache;
            } else {
                qDebug() << "Failed to clear web cache:" << webCache;
            }
        } else {
            qDebug() << "Web cache does not exist:" << webCache;
        }
    } else {
        qDebug() << "No web cache available.";
    }
}

int main(int argc, char *argv[])
{

    SimpleCrypt *crypto = new SimpleCrypt();
    crypto->setKey(0xd2fa13b37d936b07);
    //QString secret = crypto->encryptToString(QString(""));
    //qDebug() << "secret:" << secret;
    QString client_secret = crypto->decryptToString(QString(CLIENT_SECRET));

    QScopedPointer<QGuiApplication> app(Aurora::Application::application(argc, argv));

    clearWebCache();

    QScopedPointer<QQuickView> view(Aurora::Application::createView());

    app->setApplicationName("sailimgur");
    app->setOrganizationName("com.smoothie");
    app->setApplicationVersion(APP_VERSION);

    QScopedPointer<QTranslator> fallbackTranslator(new QTranslator());
    fallbackTranslator->load(QString("%1.qm").arg(PACKAGE_NAME), ":/translations");
    app->installTranslator(fallbackTranslator.data());

    QScopedPointer<QTranslator> translator(new QTranslator());
    translator->load(QLocale(), PACKAGE_NAME, "-", ":/translations");
    app->installTranslator(translator.data());

    app->installTranslator(translator.data());

    view->rootContext()->setContextProperty("APP_VERSION", APP_VERSION);
    view->rootContext()->setContextProperty("APP_RELEASE", APP_RELEASE);

    view->rootContext()->setContextProperty("CLIENT_ID", CLIENT_ID);
    view->rootContext()->setContextProperty("CLIENT_SECRET", client_secret);

    Sailimgur mgr;
    view->rootContext()->setContextProperty("sailimgurMgr", &mgr);

    qmlRegisterType<ImageUploader>("harbour.sailimgur.Uploader", 1, 0, "ImageUploader");

    view->setSource(Aurora::Application::pathTo("qml/main.qml"));
    view->show();

    return app->exec();
}
