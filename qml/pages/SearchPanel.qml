import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root;

    anchors { left: parent.left; right: parent.right }
    height: searchTextField.height

    SearchField {
        id: searchTextField;
        anchors { left: parent.left; right: parent.right }
        labelVisible: false;
        text: galleryModel.query;

        EnterKey.enabled: text.trim().length > 0;
        EnterKey.iconSource: "image://theme/icon-m-search";
        EnterKey.onClicked: {
            var searchText = searchTextField.text;

            if (searchText.indexOf("http://imgur.com") > -1) {
                searchText = searchText.substr(searchText.lastIndexOf('/') + 1);
            }

            settings.mode = constant.mode_score;
            internal.search(searchText);
            focus = false;
        }

        //% "Search from gallery"
        placeholderText: qsTrId("label-search-gallery")
    }

    QtObject {
        id: internal;

        function search(query) {
            //console.debug("Searched: " + query);
            galleryModel.query = query;
            galleryModel.clear();
            galleryModel.processGalleryMode(query);
        }
    }

}
