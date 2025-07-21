import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: root;
    allowedOrientations: Orientation.All;

    property string image_id: '';
    property int image_width: 0;
    property int image_height: 0;
    property string type: '';
    property bool animated: false;
    property string size: '';
    property int views: 0;
    property string bandwith: '';
    //property int comments: 0;
    //property int favorites: 0;
    property string section: '';
    property bool nsfw: false;
    property int ups: 0;
    property int downs: 0;

    SilicaFlickable {
        id: flickable;

        anchors.fill: parent;
        contentHeight: contentArea.height;

        PageHeader {
            id: header

            //% "Image information"
            title: qsTrId("header-image-information");
        }

        Column {
            id: contentArea;

            anchors {
                top: header.bottom;
                left: parent.left;
                right: parent.right;
                margins: Theme.horizontalPageMargin;
            }

            property var fontSize: constant.fontSizeNormal;

            height: childrenRect.height;
            spacing: constant.paddingMedium;

            anchors { left: parent.left; right: parent.right; }
            anchors { leftMargin: constant.paddingMedium; rightMargin: constant.paddingMedium; }

            DetailItem {
                //% "Id"
                label: qsTrId("detail-id")
                value: root.image_id;
            }

            DetailItem {
                //% "Width"
                label: qsTrId("detail-width")
                value: root.image_width;
            }

            DetailItem {
                //% "Height"
                label: qsTrId("detail-height")
                value: root.image_height;
            }

            DetailItem {
                //% "Type"
                label: qsTrId("detail-type")
                value: root.type;
            }

            DetailItem {
                //% "Size"
                label: qsTrId("detail-size")
                value: root.size;
            }

            DetailItem {
                //% "Views"
                label: qsTrId("detail-views")
                value: root.views;
            }

            DetailItem {
                //% "Bandwidth"
                label: qsTrId("deatail-bandwidth")
                value: root.bandwith;
            }

            DetailItem {
                //% "Section"
                label: qsTrId("detail-section")
                value: root.section;
            }

            DetailItem {
                //% "Animated"
                label: qsTrId("detail-animated")
                value: root.animated;
            }

            DetailItem {
                //% "NSFW"
                label: qsTrId("detail-nsfw")
                value: root.nsfw;
            }

            DetailItem {
                //% "Upvotes"
                label: qsTrId("detail-upvotes")
                value: root.ups;
            }

            DetailItem {
                //% "Downvotes"
                label: qsTrId("detail-downvotes")
                value: root.downs;
            }

        }

        VerticalScrollDecorator { flickable: flickable; }
    }

}
