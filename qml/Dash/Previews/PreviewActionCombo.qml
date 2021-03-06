/*
 * Copyright (C) 2014,2015 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    id: root

    implicitHeight: childrenRect.height
    implicitWidth: Math.max(moreButton.implicitWidth, column.maxButtonImplicitWidth)

    signal triggeredAction(var actionData)

    property alias model: actionRepeater.model
    property alias strokeColor: moreButton.strokeColor

    Button {
        id: moreButton
        property bool expanded: false

        objectName: "moreLessButton"
        text: !expanded ? i18n.tr("More...") : i18n.tr("Less...")
        strokeColor: theme.palette.normal.baseText
        onClicked: expanded = !expanded
        width: parent.width
    }

    Column {
        id: column
        anchors {
            top: moreButton.bottom
            topMargin: height > 0 ? spacing : 0
        }
        objectName: "buttonColumn"
        spacing: units.gu(1)
        height: moreButton.expanded ? implicitHeight : 0

        property real maxButtonImplicitWidth: 0
        function calculateImplicitWidth() {
            maxButtonImplicitWidth = 0;
            for (var i in children) {
                maxButtonImplicitWidth = Math.max(maxButtonImplicitWidth, children[i].implicitWidth);
            }
        }

        clip: true
        Behavior on height {
            UbuntuNumberAnimation {
                duration: UbuntuAnimation.SnapDuration
            }
        }

        Repeater {
            id: actionRepeater

            delegate: PreviewActionButton {
                data: modelData
                width: root.width
                onImplicitWidthChanged: column.calculateImplicitWidth();
                onClicked: root.triggeredAction(modelData)
                strokeColor: moreButton.strokeColor
            }
        }
    }
}
