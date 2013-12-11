/*
 * Copyright 2013 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 *      Nick Dedekind <nick.dedekind@canonical.com>
 */

import QtQuick 2.0
import Unity.Indicators 0.1 as Indicators
import Unity.Indicators.Network 0.1 as ICNetwork
import Unity.Indicators.Messaging 0.1 as ICMessaging
import QMenuModel 0.1 as QMenuModel
import Ubuntu.Components 0.1

Item {
    id: menuFactory

    property var menuModel: null

    property var _map:  {
        "unity.widgets.systemsettings.tablet.volumecontrol" : sliderMenu,
        "unity.widgets.systemsettings.tablet.switch"        : switchMenu,

        "com.canonical.indicator.button"    : buttonMenu,
        "com.canonical.indicator.div"       : divMenu,
        "com.canonical.indicator.section"   : sectionMenu,
        "com.canonical.indicator.progress"  : progressMenu,
        "com.canonical.indicator.slider"    : sliderMenu,
        "com.canonical.indicator.switch"    : switchMenu,

        "com.canonical.indicator.messages.messageitem"  : messageItem,
        "com.canonical.indicator.messages.sourceitem"   : groupedMessage,

        "com.canonical.unity.slider"    : sliderMenu,
        "com.canonical.unity.switch"    : switchMenu,

        "unity.widgets.systemsettings.tablet.wifisection" : wifiSection,
        "unity.widgets.systemsettings.tablet.accesspoint" : accessPoint,
    }

    Component { id: divMenu; Indicators.DivMenuItem {} }

    Component {
        id: sliderMenu;
        Indicators.SliderMenuItem {
            property QtObject menuItem: null
            property var menuModel: menuFactory.menuModel
            property var menuIndex: undefined
            property var extAttrib: menuItem && menuItem.ext ? menuItem.ext : undefined

            text: menuItem && menuItem.label ? menuItem.label : ""
            icon: menuItem && menuItem.icon ? menuItem.icon : ""
            minIcon: extAttrib && extAttrib.hasOwnProperty("minIcon") ? extAttrib.minIcon : ""
            maxIcon: extAttrib && extAttrib.hasOwnProperty("maxIcon") ? extAttrib.maxIcon : ""

            minimumValue: extAttrib && extAttrib.hasOwnProperty("minValue") ? extAttrib.minValue : 0.0
            maximumValue: {
                var maximum = extAttrib && extAttrib.hasOwnProperty("maxValue") ? extAttrib.maxValue : 1.0
                if (maximum <= minimumValue) {
                        return minimumValue + 1;
                }
                return maximum;
            }
            value: menuItem ? menuItem.actionState : 0.0
            enabled: menuItem ? menuItem.sensitive : false

            onMenuModelChanged: {
                loadAttributes();
            }
            onMenuIndexChanged: {
                loadAttributes();
            }
            onChangeState: {
                menuModel.changeState(menuIndex, value);
            }

            function loadAttributes() {
                if (!menuModel || menuIndex == undefined) return;
                menuModel.loadExtendedAttributes(menuIndex, {'min-value': 'double',
                                                          'max-value': 'double',
                                                          'min-icon': 'icon',
                                                          'max-icon': 'icon'});
            }
        }
    }

    Component {
        id: buttonMenu;
        Indicators.ButtonMenuItem {
            property QtObject menuItem: null
            property var menuModel: menuFactory.menuModel
            property var menuIndex: undefined

            text: menuItem && menuItem.label ? menuItem.label : ""
            enabled: menuItem ? menuItem.sensitive : false

            onActivate: {
                menuModel.activate(menuIndex);
                shell.hideIndicatorMenu(UbuntuAnimation.FastDuration);
            }
        }
    }
    Component {
        id: sectionMenu;
        Indicators.SectionMenuItem {
            property QtObject menuItem: null
            property var menuIndex: undefined

            text: menuItem && menuItem.label ? menuItem.label : ""
        }
    }

    Component {
        id: progressMenu;
        Indicators.ProgressMenuItem {
            property QtObject menuItem: null
            property var menuIndex: undefined

            text: menuItem && menuItem.label ? menuItem.label : ""
            icon: menuItem ? menuItem.icon : ""
            value : menuItem ? menuItem.actionState : 0.0
            enabled: menuItem ? menuItem.sensitive : false
        }
    }

    Component {
        id: standardMenu;
        Indicators.StandardMenuItem {
            property QtObject menuItem: null
            property var menuIndex: undefined

            text: menuItem && menuItem.label ? menuItem.label : ""
            icon: menuItem && menuItem.icon ? menuItem.icon : ""
            checkable: menuItem ? (menuItem.isCheck || menuItem.isRadio) : false
            checked: checkable ? menuItem.isToggled : false
            enabled: menuItem ? menuItem.sensitive : false

            onActivate: {
                menuModel.activate(menuIndex);
                shell.hideIndicatorMenu(UbuntuAnimation.BriskDuration);
            }
        }
    }

    Component {
        id: switchMenu;
        Indicators.SwitchMenuItem {
            property QtObject menuItem: null
            property var menuIndex: undefined

            text: menuItem && menuItem.label ? menuItem.label : ""
            icon: menuItem && menuItem.icon ? menuItem.icon : ""
            checked: menuItem ? menuItem.isToggled : false
            enabled: menuItem ? menuItem.sensitive : false

            onActivate: {
                menuModel.activate(menuIndex);
                shell.hideIndicatorMenu(UbuntuAnimation.BriskDuration);
            }
        }
    }

    Component {
        id: wifiSection;
        Indicators.SectionMenuItem {
            property QtObject menuItem: null
            property var menuModel: menuFactory.menuModel
            property var menuIndex: undefined
            property var extAttrib: menuItem && menuItem.ext ? menuItem.ext : undefined

            text: menuItem && menuItem.label ? menuItem.label : ""
            busy: extAttrib && extAttrib.hasOwnProperty("xCanonicalBusyAction") ? extAttrib.xCanonicalBusyAction : false

            onMenuModelChanged: {
                loadAttributes();
            }
            onMenuIndexChanged: {
                loadAttributes();
            }

            function loadAttributes() {
                if (!menuModel || menuIndex == undefined) return;
                menuModel.loadExtendedAttributes(menuIndex, {'x-canonical-busy-action': 'bool'})
            }
        }
    }

    Component {
        id: accessPoint;
        ICNetwork.AccessPoint {
            property QtObject menuItem: null
            property var menuModel: menuFactory.menuModel
            property var menuIndex: undefined
            property var extAttrib: menuItem && menuItem.ext ? menuItem.ext : undefined

            property var strengthAction: QMenuModel.UnityMenuAction {
                model: menuModel
                index: menuIndex
                name: extAttrib && extAttrib.hasOwnProperty("xCanonicalWifiApStrengthAction") ? extAttrib.xCanonicalWifiApStrengthAction : ""
            }

            text: menuItem && menuItem.label ? menuItem.label : ""
            secure: extAttrib && extAttrib.hasOwnProperty("xCanonicalWifiApIsSecure") ? extAttrib.xCanonicalWifiApIsSecure : false
            adHoc: extAttrib && extAttrib.hasOwnProperty("xCanonicalWifiApIsAdhoc") ? extAttrib.xCanonicalWifiApIsAdhoc : false
            checked: menuItem ? menuItem.isToggled : false
            signalStrength: strengthAction.valid ? strengthAction.state : 0
            enabled: menuItem ? menuItem.sensitive : false

            onMenuModelChanged: {
                loadAttributes();
            }
            onMenuIndexChanged: {
                loadAttributes();
            }
            onActivate: {
                menuModel.activate(menuIndex);
                shell.hideIndicatorMenu(UbuntuAnimation.BriskDuration);
            }

            function loadAttributes() {
                if (!menuModel || menuIndex == undefined) return;
                menuModel.loadExtendedAttributes(menuIndex, {'x-canonical-wifi-ap-is-adhoc': 'bool',
                                                          'x-canonical-wifi-ap-is-secure': 'bool',
                                                          'x-canonical-wifi-ap-strength-action': 'string'});
            }
        }
    }

    Component {
        id: messageItem
        ICMessaging.MessageMenuItemFactory {
            menuModel: menuFactory.menuModel
        }
    }

    Component {
        id: groupedMessage
        ICMessaging.GroupedMessage {
            property QtObject menuItem: null
            property var menuModel: menuFactory.menuModel
            property var menuIndex: undefined
            property var extAttrib: menuItem && menuItem.ext ? menuItem.ext : undefined

            title: menuItem && menuItem.label ? menuItem.label : ""
            count: menuItem && menuItem.actionState.length > 0 ? menuItem.actionState[0] : "0"
            appIcon: extAttrib && extAttrib.hasOwnProperty("icon") ? extAttrib.icon : "qrc:/indicators/artwork/messaging/default_app.svg"

            onMenuModelChanged: {
                loadAttributes();
            }
            onMenuIndexChanged: {
                loadAttributes();
            }
            onActivateApp: {
                menuModel.activate(menuIndex, true);
                shell.hideIndicatorMenu(UbuntuAnimation.FastDuration);
            }
            onDismiss: {
                menuModel.activate(menuIndex, false);
            }

            function loadAttributes() {
                if (!menuModel || menuIndex == undefined) return;
                menuModel.loadExtendedAttributes(modelIndex, {'icon': 'icon'});
            }
        }
    }

    function load(modelData) {
        if (modelData.type !== undefined) {
            var component = _map[modelData.type];
            if (component !== undefined) {
                return component;
            }
        } else {
            if (modelData.isSeparator) {
                return divMenu;
            }
        }
        return standardMenu;
    }
}
