import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: root

    allowedOrientations: Orientation.All;

    // TODO: Display changelog as a single formatted text
    SilicaFlickable {
        id: flickable;

        anchors.fill: parent;
        contentHeight: contentArea.height + 300;

        DialogHeader {
            id: header;

            //% "Changelog"
            title: qsTrId("header-changelog");
            //% "Close"
            acceptText: qsTrId("button-close");
        }

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right; }
            height: childrenRect.height;
            anchors.margins: Theme.paddingSmall;
            spacing: Theme.paddingSmall;

            SectionHeader { text: "Version" + " 0.10.0 (2020-12-19)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "User interface updates from patch by ichthyosaurus.";
            }

            SectionHeader { text: "Version" + " 0.9.0 (2016-07-16)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Add mode to browse subreddits. Add time window option to highest scoring and memes modes."
            }

            SectionHeader { text: "Version" + " 0.8.3 (2015-10-24)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Fix issue with fetching more comments."
            }

            SectionHeader { text: "Version" + " 0.8.2 (2015-10-10)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Fix zoom on image. Adjust UI elements for tablet."
            }

            SectionHeader { text: "Version" + " 0.8.1 (2015-08-09)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Add 'previous images' to limit showed images and to fix issues with large albums."
            }

            SectionHeader { text: "Version" + " 0.8.0 (2015-08-02)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Enable playing mp4 videos by default, enhancements regarding playing videos."
            }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Added setting to filter mature content. Showing mature content is off by default, 'safe for work'."
            }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "To open imgur link with app, paste link to search field."
            }

            SectionHeader { text: "Version" + " 0.7.4 (2015-07-26)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "New pulley actions for gallery page: open in external browser, copy link."
            }

            SectionHeader { text: "Version" + " 0.7.3 (2015-06-25)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Support for actions with TOHKBD keys. Navigation with arrow keys, backspace, M to load more, C to load comments, gallery mode changed with 1-5."
            }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Revert to showing plain animated images instead of gifv videos which aren't yet supported by Sailfish OS."
            }

            SectionHeader { text: "Version" + " 0.7.2 (2015-05-20)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Gifv videos still unplayable due missing decoders. To view them, open album with browser (pulldown menu)."
            }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Option for autoplaying gif."
            }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Fix Qt 5.2 WebView chokes on caches from older Qt versions."
            }

            SectionHeader { text: "Version" + " 0.7.1 (2014-11-25)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Use toolbar instead of sidebar for functions."
            }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Option to select toolbar position top/bottom."
            }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Account page shows user info and pages."
            }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Image info shown on page."
            }

            SectionHeader { text: "Version" + " 0.6 (2014-11-16)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "Save image to Pictures."
            }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: "User Interface adjustments: next/previous links, image and comment actions."
            }
        }

        VerticalScrollDecorator { flickable: flickable; }
    }

    onAccepted: {
        root.backNavigation = true;
    }
}
