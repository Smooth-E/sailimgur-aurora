import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: galleryContentPage;

    allowedOrientations: Orientation.All;

    property bool is_album: false;
    property bool is_gallery: true;
    property bool is_reddit: false;
    property string imgur_id : "";

    property string galleryContentPageTitle : constant.appName;

    property bool prevEnabled: currentIndex > 0 || pageNo > 0;

    GalleryContentModel {
        id: galleryContentModel;
    }

    CommentsModel {
        id: commentsModel;
    }

    signal load();
    signal removedFromModel(string imgur_id);
    signal ggpStatusChanged(int ggpStatus);

    onStatusChanged: {
        if (status === PageStatus.Deactivating) {
            // VideoComponent is listening, stopping player and destroying video on deactivation
            ggpStatusChanged(status);
        }
    }

    onLoad: {
        //console.log("galleryContentPage.onLoad: total=" + galleryContentModel.count + ", currentIndex=" + currentIndex);

        is_reddit = (settings.mode === constant.mode_reddit);

        galleryContentModel.resetVariables();
        galleryContentModel.clear();
        commentsModel.resetVariables();
        commentsModel.clear();
        loadingRectComments.visible = false;


        if (galleryModel) {
            imgur_id = galleryModel.get(currentIndex).id;
            is_album = galleryModel.get(currentIndex).is_album;
            is_gallery = galleryModel.get(currentIndex).is_gallery;
        }

        if (is_album == true) {
            galleryContentPageTitle = is_gallery == true
                                      //% "Gallery album"
                                      ? qsTrId("header-gallery-album")
                                      //% "Album"
                                      : qsTrId("header-album")
            galleryContentModel.getAlbum(imgur_id, is_gallery);
        } else {
            galleryContentPageTitle = is_gallery == true
                                      //% "Gallery image"
                                      ? qsTrId("header-gallery-image")
                                      //% "Image"
                                      : qsTrId("header-image")
            galleryContentModel.getImage(imgur_id, is_gallery);
        }

        if ((!is_reddit) && settings.showComments && is_gallery == true) {
            loadingRectComments.visible = true;
            commentsModel.getComments(imgur_id);
        }

        setPrevButton();
        flickable.scrollToTop();
    }

    onRemovedFromModel: {
        galleryModel.remove(currentIndex);
        galleryContentPage.backNavigation = true;
        pageStack.pop(PageStackAction.Animated);
    }

    function setPrevButton() {
        if (currentIndex === 0 && pageNo === 0) {
            prevEnabled = false;
        } else {
            prevEnabled = true;
        }
    }

    SilicaFlickable {
        id: flickable;
        // pressDelay: 0; // can't set this as there's Drawer

        PageHeader { id: header; title: galleryContentPageTitle; }

        PullDownMenu {
            id: pullDownMenu;

            MenuItem {
                id: imageInfoAction

                //% "Image info"
                text: qsTrId("button-image-info")
                visible: is_gallery == false

                onClicked: {
                    // TODO: Implement image info?
                }
            }

            MenuItem {
                id: submitToGalleryAction;

                //% "Submit to gallery"
                text: qsTrId("button-submit-to-gallery")
                visible: is_gallery == false

                onClicked: {
                    Imgur.submitToGallery(imgur_id, title,
                        function(data){
                            console.log("Submitted to gallery. " + data)
                            //% "Image submitted to gallery"
                            infoBanner.showText(qsTrId("label-image-submitted-to-gallery"))
                        },
                        function onFailure(status, statusText) {
                            infoBanner.showHttpError(status, statusText);
                        }
                    );
                }
            }

            /*
            MenuItem {
                id: deleteAction;
                text: qsTr("Delete image/album");
                visible: is_gallery == false;
                onClicked: {
                    deleteImageAlbum();
                }
            }*/

            MenuItem {
                //% "Open in external browser"
                text: qsTrId("button-open-in-external-browser")

                onClicked: {
                    Qt.openUrlExternally(galleryContentModel.gallery_page_link);
                }
            }

            MenuItem {
                //% "Copy link to clipboard"
                text: qsTrId("button-copy-link-to-clipboard")

                onClicked: {
                    Clipboard.text = galleryContentModel.gallery_page_link
                    //% "Link %1 copied to clipboard"
                    infoBanner.showText(qsTrId("label-link-copied").arg(Clipboard.text))
                }
            }

            MenuItem {
                //% "Open page in browser"
                text: qsTrId("button-open-in-browser")

                onClicked: {
                    var props = {
                        "url": galleryContentModel.gallery_page_link
                    }
                    pageStack.push(Qt.resolvedUrl("WebPage.qml"), props);
                }
            }

        } // Pulldown menu

        anchors.fill: parent;
        contentHeight: contentArea.height + galleryNavigation.height + albumMetaRow.height + 2 * constant.paddingMedium;
        clip: true;

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right;}
            height: childrenRect.height;
            spacing: constant.paddingMedium;

            // Shown if not in gallery, like user's albums/images
            UploadedDelegate {
                id: uploadedDelegate;
                width: parent.width;
                show_item: is_gallery == false;
                show_extra: false;
                item_is_album: is_album;
                item_title: galleryContentModel.title;
                item_imgur_id: galleryContentModel.imgur_id;
                item_link: galleryContentModel.link;
                item_deletehash: galleryContentModel.deletehash;
                item_datetime: galleryContentModel.datetime;
                parent_item: contentArea;
            }

            Separator {
                id: linkSep;
                anchors { left: parent.left; right: parent.right; }
                anchors.bottomMargin: constant.paddingLarge;
                color: constant.colorSecondary;
                visible: is_gallery == false;
            }

            Label {
                id: titleText;
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingSmall;
                anchors.rightMargin: constant.paddingSmall;

                wrapMode: Text.Wrap;
                font.pixelSize: constant.fontSizeTitle;
                color: constant.colorHighlight;
                text: galleryContentModel.title;
            }
            Label {
                id: descText;
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingSmall;
                anchors.rightMargin: constant.paddingSmall;

                wrapMode: Text.Wrap;
                font.pixelSize: constant.fontSizeNormal;
                color: constant.colorHighlight;
                text: galleryContentModel.description;
                visible: is_gallery == false;
            }

            Column {
                id: galleryContentColumn;
                anchors { left: parent.left; right: parent.right; }

                height: (topNavRow.visible) ? albumListView.height + topNavRow.height + bottomNavRow.height : albumListView.height;
                width: parent.width;

                GalleryLoadingNavigation {
                    id: topNavRow
                    model: galleryContentModel
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Flow {
                    id: albumListView;
                    height: childrenRect.height;
                    width: parent.width;
                    clip: true;

                    Repeater {
                        id: repeater;
                        model: galleryContentModel;

                        delegate: Loader {
                            asynchronous: true;

                            sourceComponent: GalleryContentDelegate {
                                id: galleryContentDelegate;
                                itemIndex: index;
                            }
                        }
                    }
                }

                GalleryLoadingNavigation {
                    id: bottomNavRow;
                    model: galleryContentModel;
                    anchors.horizontalCenter: parent.horizontalCenter;
                }
            } // galleryContentColumn

            Column {
                id: galleryLinkColumn;
                anchors {
                    left: parent.left;
                    right: parent.right;
                    leftMargin: constant.paddingMedium;
                    topMargin: constant.paddingMedium;
                }
                height: childrenRect.height;

                Row {
                    id: linkRow;
                    spacing: Theme.paddingMedium;

                    Label {
                        id: linkText;
                        font.pixelSize: constant.fontSizeIgnore;
                        text: "Gallery page: " + galleryContentModel.gallery_page_link;
                        wrapMode: Text.Wrap;
                        color: constant.colorHighlight;
                    }
                }
            } // galleryLinkColumn

            Item {
                id: pointsColumn;
                anchors {
                    left: parent.left;
                    right: parent.right;
                    leftMargin: constant.paddingMedium;
                    topMargin: constant.paddingMedium;
                }
                height: childrenRect.height;


                Row {
                    id: scoreRow;
                    spacing: Theme.paddingMedium;

                    Row {
                        id: scoreBars;
                        anchors.verticalCenter: parent.verticalCenter;

                        height: 10;
                        spacing: 0;

                        Rectangle {
                            id: scoreUps;
                            width: 100 * (galleryContentModel.upsPercent/100);
                            height: parent.height;
                            color: "green";
                        }

                        Rectangle {
                           id: scoreDowns;
                           width: 100 * (galleryContentModel.downsPercent/100);
                           height: parent.height;
                           color: "red";
                        }
                    }

                    Label {
                        id: scoreText;
                        font.pixelSize: constant.fontSizeMeta;
                        text: galleryContentModel.score + " points";
                        color: constant.colorHighlight;
                    }
                }

                IconButton {
                    id: replyButton;

                    anchors {
                        right: parent.right;
                        top: parent.top;
                    }

                    enabled: loggedIn
                    visible: loggedIn

                    icon.width: Theme.itemSizeSmall;
                    icon.height: Theme.itemSizeSmall;
                    icon.source: constant.iconComments;

                    onClicked: {
                        if (writeCommentField.visible) {
                            writeCommentField.visible = false;
                        } else {
                            writeCommentField.visible = true;
                        }
                    }
                }

                Label {
                    id: infoText;
                    anchors {
                        top: scoreRow.bottom;
                        left: parent.left;
                        margins: Theme.paddingSmall;
                    }

                    wrapMode: Text.Wrap;
                    font.pixelSize: constant.fontSizeIgnore;
                    color: constant.colorHighlight;
                    text: galleryContentModel.info;
                }

                TextArea {
                    id: writeCommentField;
                    
                    anchors {
                        top: infoText.bottom;
                        left: parent.left;
                        right: parent.right;
                        margins: Theme.paddingMedium;
                    }

                    visible: false;
                    //% "Write comment"
                    placeholderText: qsTrId("label-write-comment")

                    EnterKey.enabled: text.trim().length > 0;
                    EnterKey.iconSource: "image://theme/icon-m-enter-accept";

                    EnterKey.onClicked: {
                        Imgur.commentCreation(imgur_id, text, null,
                              function (data) {
                                // Defined in CommentDelegate.qml
                                infoBanner.showText(qsTrId("label-comment-sent"))
                                visible = false
                                text = ""
                                writeCommentField.focus = false

                                commentsModel.getComments(imgur_id)
                              },
                              function(status, statusText) {
                                  infoBanner.showHttpError(status, statusText);
                              }
                        );
                    }
                }
            }

            Column {
                id: commentsColumn;
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingSmall;
                anchors.rightMargin: constant.paddingSmall;
                height: childrenRect.height + showCommentsItem.height + galleryNavigation.height + constant.paddingMedium;
                width: parent.width;
                visible: ((is_reddit == false) && (is_gallery == true));

                Item {
                    id: showCommentsItem;
                    width: parent.width
                    height: visible ? showCommentsButton.height : 0;
                    visible: commentsModel.count == 0;

                    Button {
                        id: showCommentsButton

                        anchors.centerIn: parent
                        //% "Show comments"
                        text: qsTrId("button-show-comments")

                        onClicked: {
                            //console.log("commentsModel.count: " + commentsModel.count);
                            if(commentsModel.count > 0) {
                                commentsColumn.visible = true;
                            } else {
                                loadingRectComments.visible = true;
                                commentsModel.getComments(imgur_id);
                                commentsColumn.visible = true;
                            }
                        }
                    }
                }

                SilicaListView {
                    id: commentListView;
                    model: commentsModel;
                    height: childrenRect.height;
                    width: parent.width;
                    spacing: constant.paddingSmall;
                    clip: true;
                    visible: commentsModel.count > 0;

                    anchors.leftMargin: constant.paddingSmall;
                    anchors.rightMargin: constant.paddingSmall;

                    pressDelay: 0;
                    interactive: true;
                    boundsBehavior: Flickable.StopAtBounds;

                    delegate: Loader {
                        id: commentsLoader;
                        asynchronous: true;

                        sourceComponent: CommentDelegate {
                            id: commentDelegate;
                            width: commentListView.width
                        }
                    }
                }

                Item {
                    id: showMoreCommentsItem;
                    width: parent.width;
                    height: visible ? showMoreCommentsButton.height + 2 * constant.paddingSmall : 0;
                    visible: commentsModel.left > 0;

                    Button {
                        id: showMoreCommentsButton;
                        
                        anchors.centerIn: parent;
                        enabled: commentsModel.left > 0;
                        //% "More (%1 total, %2 remaining)"
                        text: qsTrId("button-load-more-comments").arg(commentsModel.total).arg(commentsModel.left)

                        onClicked: {
                            commentsModel.getNextComments();
                        }
                    }
                }
            } // commentsColumn

            Item {
                id: loadingRectComments;
                anchors.centerIn: commentsColumn;
                anchors.horizontalCenter: parent.horizontalCenter;
                visible: false;
                z: 2;

                BusyIndicator {
                    anchors.centerIn: parent;
                    visible: loadingRectComments.visible;
                    running: visible;
                    size: BusyIndicatorSize.Medium;
                    Behavior on opacity { FadeAnimation {} }
                }
            }

            // Shown if not in gallery, like user's albums/images
            Row {
                id: albumMetaRow;

                anchors { left: parent.left; right: parent.right; }

                width: parent.width;
                z: 1;
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;
                visible: is_gallery == false;

                Label {
                    id: datetimeText;
                    width: parent.width / 2;
                    wrapMode: Text.Wrap;
                    font.pixelSize: constant.fontSizeMeta;
                    color: constant.colorHighlight;
                    text: galleryContentModel.datetime;
                }

                Label {
                    id: viewsText

                    width: parent.width / 2;
                    wrapMode: Text.Wrap;
                    font.pixelSize: constant.fontSizeMeta;
                    color: constant.colorHighlight;
                    //% "Views: %1"
                    text: qsTrId("label-gallery-views").arg(galleryContentModel.views)
                }
            }
        }
        
        VerticalScrollDecorator { flickable: flickable; }
    }

    AlbumInfoColumn {
        id: albumInfoColumn;
    }

    GalleryNavigation {
        id: galleryNavigation;
    }

    Component.onCompleted: {
        load();
    }

}
