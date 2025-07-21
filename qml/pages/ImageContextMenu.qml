import QtQuick 2.0
import Sailfish.Silica 1.0

ContextMenu {
    id: contextMenu;
    property var url;

    Label {
        font.pixelSize: constant.fontSizeSmall;
        x: parent.x + Theme.paddingSmall;
        color: constant.colorHighlight;
        wrapMode: Text.Wrap;
        elide: Text.ElideRight;
        text: url;
    }

    Separator {
        anchors {
            left: parent.left;
            right: parent.right;
        }
        color: constant.colorSecondary;
    }

    MenuItem {
        anchors { left: parent.left; right: parent.right; }

        font.pixelSize: Screen.sizeCategory >= Screen.Large
                            ? constant.fontSizeSmall : constant.fontSizeXSmall;
        //% "Open link in browser"
        text: qsTrId("button-open-link-in-browser")

        onClicked: {
            var props = {
                "url": url
            }
            pageStack.push(Qt.resolvedUrl("WebPage.qml"), props);
        }
    }

    MenuItem {
        // Defined in GalleryContentPage.qml
        text: qsTrId("button-open-in-external-browser")

        onClicked: {
            Qt.openUrlExternally(url);
        }
    }

    MenuItem {
        // Defined in GalleryContentPage.qml
        text: qsTrId("button-copy-link-to-clipboard")

        onClicked: {
            Clipboard.text = url;
            infoBanner.showText(qsTrId("label-lnk-copied").arg(Clipboard.text));
        }
    }
}
