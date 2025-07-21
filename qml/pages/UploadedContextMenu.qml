import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

ContextMenu {
    id: uploadedContextMenu;

    property bool is_album: false;
    property string imgur_id;
    property string link;
    property string deletehash;

    MenuItem {
        anchors { left: parent.left; right: parent.right; }

        font.pixelSize: Screen.sizeCategory >= Screen.Large
                            ? constant.fontSizeSmall : constant.fontSizeXSmall;
        // Defined in ImageContextMenu.qml
        text: qsTrId("button-open-link-in-browser")

        onClicked: {
            var props = {
                "url": link
            }
            pageStack.push(Qt.resolvedUrl("WebPage.qml"), props);
            //Qt.openUrlExternally(url);
            //infoBanner.showText(qsTr("Launching browser."));
        }
    }

    MenuItem {
        anchors { left: parent.left; right: parent.right; }

        font.pixelSize: Screen.sizeCategory >= Screen.Large
                        ? constant.fontSizeSmall
                        : constant.fontSizeXSmall;
        text: qsTrId("button-copy-link-to-clipboard")

        onClicked: {
            Clipboard.text = link;
            infoBanner.showText(qsTrId("label-link-copied").arg(link))
        }
    }
    MenuItem {
        anchors { left: parent.left; right: parent.right; }

        font.pixelSize: Screen.sizeCategory >= Screen.Large
                        ? constant.fontSizeSmall
                        : constant.fontSizeXSmall
        //% "Copy delete link to clipboard"
        text: qsTrId("button-copy-delete-link-to-clipboard")

        onClicked: {
            Clipboard.text = "http://imgur.com/delete/" + deletehash;
            //% "Delete link %1 copied to clipboard."
            infoBanner.showText(qsTrId("notice-delete-link-copied-to-clipboard").arg(Clipboard.text));
        }
    }
    MenuItem {
        anchors { left: parent.left; right: parent.right; }

        font.pixelSize: Screen.sizeCategory >= Screen.Large
                        ? constant.fontSizeSmall
                        : constant.fontSizeXSmall
        //% "Delete image
        text: qsTrId("button-delete-image")

        onClicked: {
            deleteImageAlbum(imgur_id, deletehash);
        }
    }

    function deleteImageAlbum() {
        //% "Deleting image/album"
        remorse.execute(qsTrId("remorse-deleting-image-or-album"), function() {
            if (is_album) {
                Imgur.albumDeletion(imgur_id,
                    function(data){
                        //console.log("Album deleted. " + data);
                        //% "Album deleted"
                        infoBanner.showText(qsTrId("notice-album-deleted"));
                        removedFromModel(imgur_id);
                    },
                    function onFailure(status, statusText) {
                        infoBanner.showHttpError(status, statusText);
                    }
                );
            } else {
                Imgur.imageDeletion(deletehash,
                    function(data){
                        //console.log("Image deleted. " + data);
                        //% "Image deleted"
                        infoBanner.showText(qsTrId("notice-image-deleted"));
                        removedFromModel(imgur_id);
                    },
                    function onFailure(status, statusText) {
                        infoBanner.showError(status, statusText);
                        if (status === 404) {
                            removedFromModel(imgur_id);
                        }
                    }
                );
            }
        });
    }

    RemorsePopup { id: remorse }
}
