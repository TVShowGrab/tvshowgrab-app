/*
* TVShowGrab - A tvshow links grabber
* Copyright (C) 2015 Pierre Jacquier
* http://pierre-jacquier.com/
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.4
import Material 0.2
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.3 as Controls
import QtQuick.Window 2.1
import Qt.labs.settings 1.0

ApplicationWindow {
    id: root
    visible: true
    title: 'TVShowGrab'
    width: Device.isMobile ? Screen.desktopAvailableWidth : Units.dp(1000)
    height: Device.isMobile ? Screen.desktopAvailableHeight : Units.dp(600)
    property int selectedPostIndex
    property string query: ""
    theme {
        accentColor: accentchosen
        primaryColor: "#009688"
    }
    initialPage: main
    property ListModel postsModel: ListModel {
         id: postsModel
         dynamicRoles: true
     }
    Page {
        id: main
        title: "TVShowGrab"
        actionBar.hidden: true
        backgroundColor: Palette.colors.blueGrey['900']
        View {
            z: 99
            id: search
            radius: Units.dp(2)
            height: Units.dp(50)
            elevation: 2
            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
                margins: Device.isMobile ? Units.dp(10) : Units.gu(2)
                topMargin: Units.dp(10)
            }
            Row {
                spacing: Units.dp(10)
                anchors.fill:parent
                anchors.margins: Units.dp(10)
                IconButton {
                   iconName : "action/search"
                   size: Units.dp(30)
                }
                TextField {
                    id: searchInput
                    placeholderText: "Search your TV Show..."
                    showBorder: false
                    onTextChanged: getPosts(text)
                }
            }

            IconButton {
               iconName : "navigation/close"
               size: Units.dp(30)
               visible: searchInput.text != ""
               onClicked: {
                   postsModel.clear()
                   searchInput.text = ""
                }
               anchors {
                   right: parent.right
                   top: parent.top
                   margins: Units.dp(10)
               }
            }
        }
            ProgressCircle {
                id: loading
                anchors.centerIn: parent
                color: "white"
                visible: false
                indeterminate: true
            }
            ListView {
                id: listView

                anchors.fill: parent
                anchors.margins: Device.isMobile ? Units.dp(10) : Units.gu(2)
                anchors.topMargin: Units.dp(70)
                anchors.bottomMargin: 0
                model: postsModel
                delegate: ListItem.Standard {
                    textColor: "white"
                    iconColor: "white"
                    iconName: "av/movie"
                    property string title: listView.model.get(index).title
                    property string title_cut: title.substring(0, title.indexOf(' HDTV'))
                    text: title_cut == "" ? title : title_cut
                    onClicked: {
                        root.selectedPostIndex = index
                        pageStack.push(Qt.resolvedUrl("ContentPage.qml"))
                    }
                }
                }

    }

    Page {
        id: content
        title: "Content"
    }

    function getPosts(show_name) {
        postsModel.clear()

        loading.visible = true

        var promise = Http.get("http://tuserie.com/?s=" + show_name)
            .then( function(data) {
                var match;
                var re = /\<div class="post-main"\>\<h2\>\<a href="([^"]*)"\>([^\[]*)/g;
                while ((match = re.exec(data)) != null)
                {
                    postsModel.append({
                        url: match[1],
                        title: match[2]
                    });
                }

                loading.visible = false
        });
    }


    Component.onCompleted: searchInput.forceActiveFocus()
}
