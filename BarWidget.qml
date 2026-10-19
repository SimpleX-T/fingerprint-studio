import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    implicitWidth: statusRow.implicitWidth + 14
    implicitHeight: Math.max(24, statusRow.implicitHeight)

    property bool ready: false
    property bool sensorPresent: false
    property string state: "checking"
    property string serviceState: "Checking hardware…"
    property string detail: "Fingerprint Studio is checking your local device."
    property string deviceName: "No supported reader detected"
    property string lastUpdated: ""
    property var knownReaders: ["06cb:00b7", "138a:00ab"]
    property color themeForeground: typeof bar !== "undefined" ? bar.foreground : "#e8e5ec"
    property color themeBackground: typeof bar !== "undefined" ? bar.background : "#1d1c20"
    property color themeUrgent: typeof bar !== "undefined" ? bar.urgent : "#f0b7ad"

    function openStudio() {
        if (studioPanel.opened) studioPanel.close()
        else studioPanel.open()
    }

    function refresh() {
        if (!probe.running) probe.running = true
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: mouse.containsMouse ? Qt.lighter(root.themeBackground, 1.24) : "transparent"
        Behavior on color { ColorAnimation { duration: 120 } }
    }

    Row {
        id: statusRow
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: root.state === "checking" ? "◌" : "◉"
            color: root.ready ? root.themeForeground : root.state === "checking" ? root.themeForeground : root.themeUrgent
            font.pixelSize: 14
            font.weight: Font.DemiBold
        }

        Text {
            text: root.ready ? "Ready" : root.state === "checking" ? "Checking" : "Fingerprint"
            color: root.themeForeground
            font.pixelSize: 12
            font.weight: Font.Medium
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.openStudio()
    }

    Process {
        id: probe
        command: ["bash", decodeURIComponent(String(Qt.resolvedUrl("scripts/probe.sh")).replace("file://", ""))]
        property string output: ""
        stdout: SplitParser { onRead: data => probe.output += data + "\n" }
        onRunningChanged: if (running) output = ""
        onExited: exitCode => {
            const report = output.toLowerCase()
            root.sensorPresent = root.knownReaders.some(reader => report.indexOf(reader) !== -1)
            const validityReady = report.indexOf("python3_validity=active") !== -1
            const fprintdReady = report.indexOf("open_fprintd=active") !== -1
            const servicesReady = validityReady && fprintdReady
            root.ready = root.sensorPresent && servicesReady
            if (root.ready) {
                root.state = "ready"
                root.serviceState = "Ready for touch"
                root.detail = "The reader and fingerprint service are active."
                root.deviceName = report.indexOf("06cb:00b7") !== -1 ? "Synaptics 06cb:00b7" : "Validity 138a:00ab"
            } else if (root.sensorPresent) {
                root.state = "attention"
                root.serviceState = "Needs attention"
                root.detail = "Reader found, but the fingerprint service is not ready."
                root.deviceName = report.indexOf("06cb:00b7") !== -1 ? "Synaptics 06cb:00b7" : "Validity 138a:00ab"
            } else {
                root.state = "unsupported"
                root.serviceState = "No supported reader found"
                root.detail = "This version supports Synaptics 06cb:00b7 and Validity 138a:00ab."
            }
            root.lastUpdated = new Date().toLocaleTimeString(Qt.locale(), "HH:mm")
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()

    FingerprintPanel {
        id: studioPanel
        service: root
        themeForeground: root.themeForeground
        themeBackground: root.themeBackground
        themeUrgent: root.themeUrgent
    }
}
