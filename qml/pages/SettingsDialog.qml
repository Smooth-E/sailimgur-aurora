import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/storage.js" as Storage

Dialog {
    id: root;
    allowedOrientations: Orientation.All;

    signal toolbarPositionChanged;

    SilicaFlickable {
        id: settingsFlickable;

        anchors.fill: parent;

        contentHeight: contentArea.height + 300;

        DialogHeader {
            id: header

            //% "Settings"
            title: qsTrId("header-settings");
            //% "Save"
            acceptText: qsTrId("button-save");
        }

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right }
            width: parent.width
            height: childrenRect.height;

            Slider {
                value: settings.albumImagesLimit;
                minimumValue: 1;
                maximumValue: 10;
                stepSize: 1;
                width: parent.width;
                valueText: value;
                //% "Images shown in album"
                label: qsTrId("preference-images-shown-in-album")

                onValueChanged: {
                    settings.albumImagesLimit = value;
                }
            }

            TextSwitch {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;

                //% "Show comments"
                text: qsTrId("preference-show-comments")
                checked: settings.showComments;

                onClicked: {
                    checked ? settings.showComments = true : settings.showComments = false;
                }
            }

            Label {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;

                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall;
                //% "Load comments automatically"
                text: qsTrId("preference-auto-load-comments")
            }

            Label {
                anchors { left:parent.left;}

                //% "Reddit sub:"
                text: qsTrId("preference-reddit-sub");
                font.pixelSize: constant.fontSizeMedium;
            }

            TextField {
                id: redditSubInput

                anchors { right: parent.right;}
                width: parent.width / 1.1;
                placeholderText: settings.redditSub
            }


            TextSwitch {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;

                //% "Show mature content"
                text: qsTrId("preference-show-mature-content")
                checked: settings.showNsfw;

                onClicked: {
                    checked ? settings.showNsfw = true : settings.showNsfw = false;
                }
            }
            Label {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;

                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall;
                wrapMode: Text.Wrap;
                //% "Mature posts and comments may include sexually suggestive or adult-oriented content."
                text: qsTrId("preference-show-mature-content-description");
            }

            TextSwitch {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;

                //% "Autoplay videos / images"
                text: qsTrId("preference-autoplay")
                checked: settings.playImages;

                onClicked: {
                    checked ? settings.playImages = true : settings.playImages = false;
                }
            }

            Label {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;

                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall;
                wrapMode: Text.Wrap;
                //% "Autoplay animated images (gif/gifv). Disabling autoplay may help with showing large albums."
                text: qsTrId("preference-autoplay-description");
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
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;

                //% "Use video player"
                text: qsTrId("preference-use-video-player")
                checked: settings.useVideoLoader;

                onClicked: {
                    checked ? settings.useVideoLoader = true : settings.useVideoLoader = false;
                }
            }

            Label {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;

                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall;
                wrapMode: Text.Wrap;
                //% "Use video player to play gifv videos (mp4)."
                text: qsTrId("preference-use-video-player-description")
            }

            TextSwitch {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;

                //% "Hide toolbar when scrolling"
                text: qsTrId("preference-hide-toolbar-when-scrolling")
                checked: settings.toolbarHidden;

                onClicked: {
                    checked ? settings.toolbarHidden = true : settings.toolbarHidden = false;
                }
            }

            TextSwitch {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;

                //% "Toolbar on bottom"
                text: qsTrId("preference-bottom-toolbar");
                checked: settings.toolbarBottom

                onClicked: {
                    checked ? settings.toolbarBottom = true : settings.toolbarBottom = false;
                    toolbarPositionChanged();
                }
            }
            Label {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;

                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall;
                //% "Might need to restart the app to work correctly."
                text: qsTrId("prefrence-bottom-toolbar-description")
            }
        }

        VerticalScrollDecorator { flickable: settingsFlickable; }
    }

    onAccepted: {
        var oldRedditSub = settings.redditSub;

        // Upon change, and reddit mode activated -- reset gallery.
        if (oldRedditSub !== redditSubInput.text.trim()){
            settings.redditSub = redditSubInput.text.trim();

            if (settings.mode === constant.mode_reddit){
                galleryModel.clear();
                galleryModel.processGalleryMode(galleryModel.query);
            }
        }
        settings.saveSettings();
    }
}
