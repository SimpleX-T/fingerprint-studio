import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: root
    property var service
    signal dismissed()

    modal: false
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    width: 390
    height: content.implicitHeight + 28
    x: Math.max(16, (parent ? parent.width : 1440) - width - 24)
    y: 42
    padding: 0
    onClosed: dismissed()

    background: Rectangle {
        radius: 16
        color: "#202024"
        border.color: "#3b3b42"
        border.width: 1
    }

    contentItem: ColumnLayout {
        id: content
        width: root.width - 32
        spacing: 0

        Item { Layout.preferredHeight: 18 }

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Fingerprint Studio"
                color: "#f4f1f5"
                font.pixelSize: 18
                font.weight: Font.DemiBold
                Layout.fillWidth: true
            }
            Button {
                text: "Close"
                flat: true
                onClicked: root.close()
            }
        }

        Item { Layout.preferredHeight: 16 }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 112
            radius: 12
            color: root.service && root.service.ready ? "#1e3529" : "#362727"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 5
                Text {
                    text: root.service && root.service.ready ? "●  Ready for touch" : "●  " + (root.service ? root.service.serviceState : "Checking hardware…")
                    color: root.service && root.service.ready ? "#a7e9ae" : "#ffc0b7"
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                }
                Text {
                    text: root.service ? root.service.deviceName : "Checking hardware…"
                    color: "#f4f1f5"
                    font.pixelSize: 16
                    font.weight: Font.Medium
                }
                Text {
                    text: root.service ? root.service.detail : ""
                    color: "#c8c3ca"
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }
        }

        Item { Layout.preferredHeight: 12 }

        Label { text: "Local health, never a hidden repair"; color: "#aaa4ac"; font.pixelSize: 12; font.weight: Font.DemiBold }

        Repeater {
            model: [
                ["1", "Inspect", "Read-only local hardware and service checks."],
                ["2", "Understand", "Open the evidence and diagnostics before changing anything."],
                ["3", "Decide", "Fingerprint Studio never runs privileged repair commands itself."]
            ]
            delegate: RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 12
                spacing: 10
                Rectangle { Layout.preferredWidth: 22; Layout.preferredHeight: 22; radius: 11; color: "#34343b"; Text { anchors.centerIn: parent; text: modelData[0]; color: "#f4f1f5"; font.pixelSize: 12; font.weight: Font.DemiBold } }
                ColumnLayout {
                    Layout.fillWidth: true; spacing: 2
                    Text { text: modelData[1]; color: "#f4f1f5"; font.pixelSize: 13; font.weight: Font.DemiBold }
                    Text { text: modelData[2]; color: "#aaa4ac"; font.pixelSize: 12; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                }
            }
        }

        Item { Layout.preferredHeight: 18 }

        RowLayout {
            Layout.fillWidth: true
            Text { text: root.service && root.service.lastUpdated ? "Updated " + root.service.lastUpdated : ""; color: "#827c84"; font.pixelSize: 11; Layout.fillWidth: true }
            Button { text: "Refresh"; onClicked: root.service.refresh() }
            Button { text: "Evidence"; onClicked: Qt.openUrlExternally("https://github.com/uunicorn/python-validity/pull/256") }
        }

        Item { Layout.preferredHeight: 16 }
    }
}
