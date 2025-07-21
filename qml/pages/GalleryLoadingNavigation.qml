import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Row {
    property var model
    spacing: 0

    width: parent.width
    height: prevButton.height + 2*Theme.paddingSmall

    visible: (prevButton.enabled || nextButton.enabled) && model.total > 1

    Button {
        id: prevButton

        width: parent.width/2
        enabled: model.prev > 0

        text: enabled
              //% "Previous (%1 left)"
              ? qsTrId("button-previous-gallery-page-with-info").arg(model.prev ? model.prev : 0)
              //% "Previous"
              : qsTrId("button-previous-gallery-page")

        onClicked: {
            model.getPrevImages();
        }
    }

    Button {
        id: nextButton

        width: parent.width/2
        enabled: model.left > 0

        text: enabled
              //% "next (%2/%1 left)"
              ? qsTrId("button-next-gallery-page-with-info")
                .arg(model.total ? model.total : 0)
                .arg(model.left ? model.left : 0)
              //% "next"
              : qsTrId("button-next-gallery-page")

        onClicked: {
            if (settings.useGalleryPage) {
                pageStack.push(Qt.resolvedUrl("GalleryItemPage.qml"));
            } else {
                model.getNextImages();
            }
        }
    }
}
