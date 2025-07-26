import QtQuick 2.0
import Sailfish.Silica 1.0
import Aurora.Controls 1.0
import "../components/storage.js" as Storage

Page {
    id: root

    allowedOrientations: Orientation.All

    signal toolbarPositionChanged

    onStatusChanged: {
        if (status !== PageStatus.Deactivating) {
            return
        }

        var oldRedditSub = settings.redditSub

        // Upon change, and reddit mode activated -- reset gallery.
        if (oldRedditSub !== redditSubInput.text.trim()) {
            settings.redditSub = redditSubInput.text.trim()

            if (settings.mode === constant.mode_reddit) {
                galleryModel.clear()
                galleryModel.processGalleryMode(galleryModel.query)
            }
        }

        settings.saveSettings()
    }

    AppBar {
        id: header

        //% "Settings"
        headerText: qsTrId("header-settings")
    }

    SilicaFlickable {
        id: settingsFlickable;

        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        contentHeight: contentArea.height

        Column {
            id: contentArea

            anchors {
                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
            }

            height: childrenRect.height

            Slider {
                value: settings.albumImagesLimit;
                minimumValue: 1
                maximumValue: 10
                stepSize: 1
                width: parent.width
                valueText: value
                //% "Images shown in album"
                label: qsTrId("preference-images-shown-in-album")

                onValueChanged: settings.albumImagesLimit = value
            }

            TextSwitch {
                width: parent.width
                //% "Show comments"
                text: qsTrId("preference-show-comments")
                checked: settings.showComments

                onClicked: settings.showComments = checked
            }

            Label {
                width: parent.width
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                ? constant.fontSizeSmall
                                : constant.fontSizeXSmall
                //% "Load comments automatically"
                text: qsTrId("preference-auto-load-comments")
            }

            Label {
                width: parent.width
                //% "Reddit sub:"
                text: qsTrId("preference-reddit-sub")
                font.pixelSize: constant.fontSizeMedium
            }

            TextField {
                id: redditSubInput

                width: parent.width
                placeholderText: settings.redditSub
            }


            TextSwitch {
                width: parent.width
                //% "Show mature content"
                text: qsTrId("preference-show-mature-content")
                checked: settings.showNsfw

                onClicked:settings.showNsfw = checked
            }

            Label {
                width: parent.width
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                ? constant.fontSizeSmall
                                : constant.fontSizeXSmall
                wrapMode: Text.Wrap;
                //% "Mature posts and comments may include sexually suggestive or adult-oriented content."
                text: qsTrId("preference-show-mature-content-description");
            }

            TextSwitch {
                width: parent.width
                //% "Autoplay videos / images"
                text: qsTrId("preference-autoplay")
                checked: settings.playImages

                onClicked: settings.playImages = checked
            }

            Label {
                width: parent.width
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                ? constant.fontSizeSmall
                                : constant.fontSizeXSmall
                wrapMode: Text.Wrap;
                //% "Autoplay animated images (gif/gifv). Disabling autoplay may help with showing large albums."
                text: qsTrId("preference-autoplay-description")
            }

            /*
            TextSwitch {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;
                text: qsTr("Show album images in own page");
                checked: settings.useGalleryPage;
                onClicked: {
                    checked ? settings.useGalleryPage = true : settings.useGalleryPage = false;
                }
            }
            Label {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall;
                wrapMode: Text.Wrap;
                text: qsTr("Open gallery album in own page. May help with showing large albums.");
            }
            */

            TextSwitch {
                width: parent.width
                //% "Use video player"
                text: qsTrId("preference-use-video-player")
                checked: settings.useVideoLoader

                onClicked: settings.useVideoLoader = checked
            }

            Label {
                width: parent.width
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                ? constant.fontSizeSmall
                                : constant.fontSizeXSmall
                wrapMode: Text.Wrap;
                //% "Use video player to play gifv videos (mp4)."
                text: qsTrId("preference-use-video-player-description")
            }

            TextSwitch {
                width: parent.width
                //% "Hide toolbar when scrolling"
                text: qsTrId("preference-hide-toolbar-when-scrolling")
                checked: settings.toolbarHidden

                onClicked: settings.toolbarHidden = checked
            }

            TextSwitch {
                width: parent.width
                //% "Toolbar on bottom"
                text: qsTrId("preference-bottom-toolbar");
                checked: settings.toolbarBottom

                onClicked: {
                    settings.toolbarBottom = checked
                    toolbarPositionChanged();
                }
            }

            Label {
                width: parent.width
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                ? constant.fontSizeSmall
                                : constant.fontSizeXSmall
                //% "Might need to restart the app to work correctly."
                text: qsTrId("prefrence-bottom-toolbar-description")
                wrapMode: Text.Wrap
            }
        }

        VerticalScrollDecorator {
            flickable: settingsFlickable
        }
    }
}
