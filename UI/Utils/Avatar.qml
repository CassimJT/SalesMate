import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: avatarRect

    // Public properties
    property alias imageSource: imageObj.source
    property alias defaultImageSource: imageObj.defaultSource
    property alias editIconSource: editIcon.source
    property color iconBackgroundColor: Qt.rgba(0, 0, 0, 0) // Transparent by default
    property real iconBorderWidth: 0 // Default no border
    property int avatarSize: 85 // Default avatar size
    property real  iconInsidebackgroundScaleFactor: 0
    signal clicked

    width: avatarSize
    height: avatarSize
    radius: width / 2
    color: Qt.rgba(0, 0, 0, 0)
    clip: true

    Canvas {
        id: avatarCanvas
        anchors.fill: parent

        onPaint: {
            const ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            // Drawing a circular mask
            ctx.beginPath();
            ctx.arc(width / 2, height / 2, width / 2, 0, 2 * Math.PI);
            ctx.clip();

            // Drawing the image onto the canvas
            if (imageObj.status === Image.Ready) {
                ctx.drawImage(imageObj, 0, 0, width, height);
            } else {
                // Optionally draw a placeholder or background
                ctx.fillStyle = "#CCCCCC"; // Placeholder color
                ctx.fillRect(0, 0, width, height);
            }
        }

        Component.onCompleted: {
            requestPaint(); // Trigger the canvas painting
        }
    }

    // Offscreen QML Image to load the source
    Image {
        id: imageObj
        property string defaultSource: "qrc:/Asserts/icons/profile.png"
        source: avatarRect.defaultImageSource || avatarRect.imageSource
        visible: false // Hiding it as it's only needed for Canvas
        onStatusChanged: {
            if (status === Image.Ready || status === Image.Error) {
                avatarCanvas.requestPaint(); // Repaint the canvas when the image is ready or fails to load
            }
        }
    }

    // Edit icon with customizable background
    Rectangle {
        id: iconBackground
        width: avatarRect.avatarSize * 0.3
        height: width
        radius: width / 2
        color: avatarRect.iconBackgroundColor // Default transparent
        border.width: avatarRect.iconBorderWidth
        anchors {
            bottom: parent.bottom
            right: parent.right
        }

        // Edit icon inside the background
        Image {
            id: editIcon
            width: parent.width * avatarRect.iconInsidebackgroundScaleFactor
            height: width
            source: "qrc:/Asserts/icons/Edit.png" // Default icon
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                avatarRect.clicked(); // Emit the `clicked` signal
            }
        }
    }
}
