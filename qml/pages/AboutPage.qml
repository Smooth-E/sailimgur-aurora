import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: aboutPage;
    allowedOrientations: Orientation.All;

    signal load;

    Connections {
        target: settings;
        onSettingsLoaded: {
            Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken, constant.userAgent);
        }
    }

    SilicaFlickable {
        id: aboutFlickable;

        anchors.fill: parent;
        contentHeight: contentArea.height + 2 * constant.paddingLarge;

        PageHeader {
            id: header

            //% "About Sailimgur"
            title: qsTrId("header-sailimgur");
        }

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right }
            height: childrenRect.height;

            anchors.leftMargin: constant.paddingMedium;
            anchors.rightMargin: constant.paddingMedium;

            Item {
                anchors { left: parent.left; right: parent.right; }
                height: aboutText.height;

                Label {
                    id: aboutText

                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeLarge : constant.fontSizeMedium
                    //% "Sailimgur is a simple <a href='http://imgur.com'>Imgur</a> app for Sailfish OS, powered by Qt, QML and JavaScript.\nIt has a simple, native and easy-to-use UI. Sailimgur is Open Source and licensed under GPL v3."
                    text: qsTrId("description-about-sailimgur");
                    textFormat: Text.StyledText
                    linkColor: Theme.highlightColor

                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }

            SectionHeader {
                //% "Version"
                text: qsTrId("label-version")
            }

            Item {
                anchors { left: parent.left; right: parent.right; }
                height: versionText.height;

                ListItem {
                    Label {
                        id: versionText;
                        font.pixelSize: Screen.sizeCategory >= Screen.Large
                                            ? constant.fontSizeLarge : constant.fontSizeMedium
                        text: APP_VERSION + "-" + APP_RELEASE;
                    }

                    Label {
                        id: changeLog

                        anchors { right: parent.right; leftMargin: constant.paddingLarge; rightMargin: constant.paddingLarge; }

                        font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeLarge
                                        : constant.fontSizeMedium
                        //% "Changelog"
                        text: qsTrId("button-view-changelog");
                        color: Theme.highlightColor;

                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                pageStack.push(Qt.resolvedUrl("ChangelogDialog.qml"));
                            }
                        }
                    }
                }
            }

            SectionHeader {
                //% "Developed by"
                text: qsTrId("label-developed-by")
            }

            ListItem {
                id: root;

                Image {
                    id: rotImage;
                    source: "../images/rot_tr_86x86.png";
                    width: 86;
                    height: 86;
                }
                Label {
                    anchors { left: rotImage.right; leftMargin: constant.paddingLarge;}
                    text: "Marko Wallin, @walokra"
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeXLarge : constant.fontSizeLarge
                }
            }

            Label {
                anchors { right: parent.right; rightMargin: Theme.paddingLarge; }
                textFormat: Text.StyledText;
                linkColor: Theme.highlightColor;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeMedium : constant.fontSizeSmall
                truncationMode: TruncationMode.Fade;
                //% "Bug reports: %1"
                text: qsTrId("label-bug-reports").arg("<a href='https://github.com/walokra/sailimgur/issues'>Github</a>")

                onLinkActivated: Qt.openUrlExternally(link)
            }

            SectionHeader {
                //% "Powered by"
                text: qsTrId("label-powered-by")
            }

            ListItem {
                Image {
                    id: imgurImage;
                    source: "../images/imgur-logo.svg";
                    width: 150;
                    height: 54;
                }
                Label {
                    anchors { left: imgurImage.right; leftMargin: constant.paddingLarge; }
                    text: "<a href='http://imgur.com'>Imgur</a>";
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeXLarge : constant.fontSizeLarge
                    textFormat: Text.StyledText;
                    linkColor: Theme.highlightColor;

                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }

            ListItem {
                Image {
                    id: qtImage;
                    source: "../images/qt_icon.png";
                    width: 80;
                    height: 80;
                }
                Label {
                    anchors { left: qtImage.right; leftMargin: constant.paddingLarge; }

                    //% "%1 and %2"
                    text: qsTrId("label-qt-and-qml").arg("Qt").arg("Qml")
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeXLarge : constant.fontSizeLarge
                }
            }

            SectionHeader {
                //% "Imgur API rate limits"
                text: qsTrId("label-imgur-api-rate-limits")
            }

            Label {
                id: creditsText

                width: parent.width;
                height: 100;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                ? constant.fontSizeSmall
                                : constant.fontSizeXSmall
                //% "Remaining: %1 - %2, client - %3"
                text: qsTrId("label-remaining-api-requests").arg(settings.user).arg(main.creditsRemaining).arg(main.creditsClientRemaining)
            }
        }
        ScrollDecorator {}
    }

    onLoad: {
        Imgur.getCredits(
            function(userRemaining, clientRemaining){
                creditsUserRemaining = userRemaining;
                creditsClientRemaining = clientRemaining;
            },
            function(status, statusText){
            }
        );
    }

}
