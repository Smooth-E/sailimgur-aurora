import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    anchors {
        left: parent.left;
        right: parent.right;
    }

    height: childrenRect.height + Theme.horizontalPageMargin;
    spacing: Theme.paddingSmall;

    Connections {
        target: mp;
        onModeChanged: {
            internal.setMode(mode);
        }
    }

    Connections {
        target: settings;

        onSettingsLoaded: {
            internal.setMode(settings.mode);

            switch (settings.sort) {
                case "viral":
                    sortBox.currentIndex = 0;
                    break;
                case "time":
                    sortBox.currentIndex = 1;
                    break;
                case "top":
                    sortBox.currentIndex = 2;
                    break;
                default:
                    sortBox.currentIndex = 0;
            }
        }
    }

    Label {
        id: accountModeLabel

        width: parent.width;
        height: constant.itemSizeMedium

        text: settings.mode === constant.mode_favorites 
              //% "Your favorite images"
              ? qsTrId("label-your-favorite-images")
              : settings.mode === constant.mode_albums
                //% "Your albums"
                ? qsTrId("label-your-albums")
                : settings.mode === constant.mode_images
                  //% "Your images"
                  ? qsTrId("label-your-images")
                  : ""
        
        font.pixelSize: constant.fontSizeTitle;
        color: constant.colorHighlight;
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
        visible: settings.mode === constant.mode_favorites
                 || settings.mode === constant.mode_albums
                 || settings.mode === constant.mode_images
    }

    ComboBox {
        id: modeBox;
        currentIndex: 0;
        width: (settings.sort !== "top" || settings.mode === constant.mode_score)
                ? parent.width / 2 : parent.width / 3;
        visible: (accountModeLabel.visible == false && galleryModel.query === "");

        menu: ContextMenu {
            MenuItem {
                id: mainMode

                //% "Most viral"
                text: qsTrId("option-most-viral")

                onClicked: {
                    internal.setMode(constant.mode_main);
                }
            }

            MenuItem {
                id: userMode

                //% "User submitted"
                text: qsTrId("option-user-submitted")

                onClicked: {
                    internal.setMode(constant.mode_user);
                }
            }

            MenuItem {
                id: randomMode

                //% "Random"
                text: qsTrId("option-random")

                onClicked: {
                    internal.setMode(constant.mode_random);
                }
            }

            MenuItem {
                id: scoreMode

                //% "Highest scoring"
                text: qsTrId("option-highest-scoring")

                onClicked: {
                    internal.setMode(constant.mode_score);
                }
            }

            MenuItem {
                id: memesMode

                //% "Memes"
                text: qsTrId("option-memes")

                onClicked: {
                    internal.setMode(constant.mode_memes);
                }
            }

            MenuItem {
                id: redditMode

                //% "Reddit"
                text: qsTrId("option-reddit")
                
                onClicked: {
                    internal.setMode(constant.mode_reddit);
                }
            }

        }
    }

    ComboBox {
        id: sortBox

        width: (settings.sort !== "top" || settings.mode === constant.mode_score)
                ? parent.width / 2 : parent.width / 3;
        currentIndex: 0
        //% "Sort by"
        label: qsTrId("label-sort-by")
        visible: accountModeLabel.visible == false;

        menu: ContextMenu {
            MenuItem {
                id: viralSort

                //% "Popularity"
                text: qsTrId("option-popularity");
                visible: (settings.mode !== constant.mode_reddit)

                onClicked: {
                    settings.sort = "viral";
                    internal.setSortCommon();
                }
            }

            MenuItem {
                id: newestSort

                //% "Newest"
                text: qsTrId("option-newest")

                onClicked: {
                    settings.sort = "time";
                    internal.setSortCommon();
                }
            }

            MenuItem {
                id: topSort

                //% "Top"
                text: qsTrId("option-top");
                visible: (settings.mode === constant.mode_score
                          || settings.mode === constant.mode_memes
                          || settings.mode === constant.mode_reddit)
                
                onClicked: {
                    settings.sort = "top";
                    internal.setSortCommon();
                }
            }
        }
    }

    ComboBox {
        id: windowBox

        width: (settings.sort !== "top" || settings.mode === constant.mode_score)
                ? parent.width / 2 : parent.width / 3;
        currentIndex: 0;
        visible: (accountModeLabel.visible == false &&
                  settings.sort === "top" &&
                  settings.mode !== constant.mode_random);

        menu: ContextMenu {
            MenuItem {
                id: dayWind

                //% "Day"
                text: qsTrId("window-day");
                
                onClicked: {
                    settings.window = "day";
                    internal.setWindowCommon();
                }
            }

            MenuItem {
                id: weekWind

                //% "Week"
                text: qsTrId("window-week")

                onClicked: {
                    settings.window = "week";
                    internal.setWindowCommon();
                }
            }

            MenuItem {
                id: monthWind;

                //% "Month"
                text: qsTrId("window-month");
                onClicked: {
                    settings.window = "month";
                    internal.setWindowCommon();
                }
            }

            MenuItem {
                id: yearWind

                //% "Year"
                text: qsTrId("window-year")

                onClicked: {
                    settings.window = "year";
                    internal.setWindowCommon();
                }
            }

            MenuItem {
                id: allWind

                //% "All"
                text: qsTrId("window-all")

                onClicked: {
                    settings.window = "all";
                    internal.setWindowCommon();
                }
            }
        }
    }

    QtObject {
        id: internal;

        function setMode(mode) {
            if (mode === constant.mode_main) {
                modeBox.currentIndex = 0;
                sortBox.visible = true;
                sortBox.currentIndex = 0;
                // There's no top sort
                if (settings.sort === "top") {
                    settings.sort = "viral";
                }
                settings.mode = constant.mode_main;
                settings.section = "hot";
                settings.window = "day";
            } else if (mode === constant.mode_user) {
                modeBox.currentIndex = 1;
                sortBox.visible = true;
                settings.mode = constant.mode_user;
                settings.section = constant.mode_user;
                if (settings.sort === "top") {
                    settings.sort = "viral";
                }
                settings.window = "day";
            } else if (mode === constant.mode_random) {
                modeBox.currentIndex = 2;
                sortBox.visible = false;
                settings.mode = constant.mode_random;
            } else if (mode === constant.mode_score) {
                modeBox.currentIndex = 3;
                sortBox.visible = false;
                settings.mode = constant.mode_score;
                settings.section = "top";
                settings.sort = "top";
            } else if (mode === constant.mode_memes) {
                modeBox.currentIndex = 4;
                sortBox.currentIndex = 1;
                sortBox.visible = true;
                settings.sort = "time";
                windowBox.currentIndex = 1;
                settings.window = "week";
                settings.mode = constant.mode_memes;
            } else if (mode === constant.mode_reddit) {
                modeBox.currentIndex = 5;
                sortBox.visible = true;
                sortBox.currentIndex = 1;
                settings.sort = "time";
                windowBox.currentIndex = 1;
                settings.window = "week";
                settings.showViral = false;
                settings.showComments = false;
                settings.mode = constant.mode_reddit;
            } else {
                modeBox.currentIndex = 0;
                sortBox.visible = true;
                settings.mode = constant.mode_main;
                settings.section = "hot";
            }
            internal.setModeCommon();
        }

        function setModeCommon() {
            settings.saveSetting("mode", settings.mode);
            pageNo = 0;
            galleryModel.query = "";
            toolbar.searchVisible = false;
            galgrid.scrollToTop();
            galleryModel.clear();
            galleryModel.processGalleryMode();
        }

        function setSortCommon() {
            settings.saveSetting("sort", settings.sort);
            galgrid.scrollToTop();
            galleryModel.clear();
            galleryModel.processGalleryMode(galleryModel.query);
        }

        function setWindowCommon() {
            settings.saveSetting("window", settings.window);
            galgrid.scrollToTop();
            galleryModel.clear();
            galleryModel.processGalleryMode(galleryModel.query);
        }
    }

}
