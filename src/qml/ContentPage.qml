import QtQuick 2.4
import Material 0.2
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1
import QtQuick.Controls 1.3 as Controls

Page {
    id: contentPage
    title: postsModel.get(selectedPostIndex).title.substring(0, postsModel.get(selectedPostIndex).title.indexOf(' HDTV'))
    property string link: ""
    property string link_title: ""
    property string link_desc: ""


    property ListModel linksModel: ListModel {
         id: linksModel
         dynamicRoles: true
     }

    actionBar.backgroundColor: Palette.colors.blueGrey['900']

    ListView {
        anchors {
            fill: parent
            margins: Units.gu(1)
            topMargin: Units.dp(10)
        }
        model: linksModel
        spacing: Units.dp(10)
        delegate: Card {
            width: parent.width
            height: Units.dp(100)

            Column {
                id: column
                anchors.fill: parent
                anchors.margins: Units.dp(20)
                Label {
                    text: linksModel.get(index).link_title
                    style: "title"
                }

                Label {
                    text: linksModel.get(index).link_desc
                    style: "sub_heading"
                }
            }

            Button {
                text: "Lien MEGA"
                elevation: 0
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    margins: Units.dp(20)
                }

                textColor: Theme.accentColor
                onClicked: {
                    var promise = Http.get("http://api.longurl.org/v2/expand?url=" + linksModel.get(index).link + "&format=json")
                        .then( function(data) {
                            Qt.openUrlExternally(JSON.parse(data)['long-url'])
                    });
                }
            }
        }
    }


    ProgressCircle {
        id: links_loading
        anchors.centerIn: parent
        color: Theme.accentColor
        visible: false
        indeterminate: true
    }



    Component.onCompleted: getLink(postsModel.get(selectedPostIndex).url)

    function getLink(url) {
        var posts = []
        links_loading.visible = true
        var promise = Http.get(url)
            .then( function(data) {
                linksModel.clear();
                var match;
                var re = /\<p style="text-align: center;"\>\<strong\>([^<]*)\<\/strong\>\<br \/\> ([^<]*)\<br \/\> \<strong\>\<a href="([^"]*)"\>MEGA/g;
                while ((match = re.exec(data)) != null) {
                    linksModel.append({
                      link_title: match[1],
                      link_desc: match[2],
                      link: match[3]
                    })
                }
                links_loading.visible = false
        });
    }
}
