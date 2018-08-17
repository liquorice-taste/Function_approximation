import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.2

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Function approximation")
    property var arrpoints : []
    Button {
        id: button
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        text: "Approximate"
        onClicked: {
            mycanvas.drawapprox()
            mycanvas.requestPaint()
        }
    }
    
    Canvas {
        id: mycanvas
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: button.top
        

        MouseArea {
            id: mymouse
            anchors.fill: parent
            onClicked: {
                arrpoints.push(Qt.point(mouseX, mouseY))
                console.log(mouseX, mouseY)
                mycanvas.requestPaint()
            }
        }
        onPaint: {
            var context = getContext("2d");
            //context.reset();
            context.strokeStyle = Qt.rgba(0, 1, 1, 0)
            for(var i = 0; i < arrpoints.length; i++){
                context.ellipse(arrpoints[i].x, arrpoints[i].y, 5, 5)
            }
            context.fill()
            context.stroke()
        }
        function drawapprox(){
            var ctx = getContext("2d")
            ctx.reset();
            ctx.lineWidth = 5;
            ctx.strokeStyle = "red"
            ctx.beginPath()
            var ab = calculateab()
            ctx.moveTo(-(ab.y/ab.x), ab.y)
            ctx.lineTo((mycanvas.height - ab.y) / ab.x, ab.x * mycanvas.width + ab.y)
            ctx.closePath()
            ctx.stroke()
        }
    }
    
    function calculateab(){
        var a, b, i, sumx = 0, sumy = 0, sumx2 = 0, sumxy = 0;
        for (i = 0; i < arrpoints.length; i++){
            sumx = sumx + arrpoints[i].x;
            sumy = sumy + arrpoints[i].y;
            sumx2 = sumx2 + arrpoints[i].x * arrpoints[i].x;
            sumxy = sumxy + arrpoints[i].x * arrpoints[i].y;
        }
        console.log(sumx, sumy, sumx2, sumxy)
        console.log(arrpoints.length)
        a = (arrpoints.length*sumxy - sumx*sumy)/(arrpoints.length*sumx2 - sumx*sumx)
        b = (sumy - a * sumx)/arrpoints.length
        console.log(a)
        var ab = Qt.point(a,b)
        return ab
    }
}
