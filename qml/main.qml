import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.12
import Qt.labs.settings 1.0

import OpenHD 1.0

import "./ui"
import "./ui/widgets"


ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 800
    height: 480
    minimumHeight: 320
    minimumWidth: 480
    title: qsTr("Open.HD")
    color: EnableMainVideo ? "black" : "#00000000"

    visibility: UseFullscreen ? "FullScreen" : "AutomaticVisibility"

    property bool initialised: false

    onAfterSynchronizing: {
        if (!initialised) {
            hudOverlayGrid.messageHUD.pushMessage("Initializing", 1)

            initialised = true;
            if (EnableMainVideo) {
                MainStream.startVideo();
            }
            if (EnablePiP) {
                PiPStream.startVideo();
            }
        }
    }

    // this is not used but must stay right here, it forces qmlglsink to completely
    // initialize the rendering system early. Without this, the next GstGLVideoItem
    // to be initialized, depending on the order they appear in the QML, will simply
    // not work on desktop linux.
    Loader {
        source:  (EnableMainVideo && EnablePiP)  ? "DummyVideoItem.qml" : ""
    }

    /*
     * Local app settings. Uses the "user defaults" system on Mac/iOS, the Registry on Windows,
     * and equivalent settings systems on Linux and Android
     *
     */
    Settings {
        id: settings
        property int main_video_port: 5600
        property int pip_video_port: 5601
        property int battery_cells: 3
        property bool show_pip_video: false
        property bool enable_software_video_decoder: false
        property bool enable_rtp: true

        property bool enable_speech: true
        property bool enable_imperial: false
        property bool enable_rc: false

        property bool show_downlink_rssi: true
        property bool show_uplink_rssi: true
        property bool show_bitrate: true
        property bool show_air_battery: true
        property bool show_gps: true
        property bool show_home_distance: true
        property bool show_flight_timer: true
        property bool show_flight_mode: true
        property bool show_ground_status: true
        property bool show_air_status: true
        property bool show_message_hud: true
        property bool show_horizon: true
        property bool show_fpv: true
        property bool show_altitude: true
        property bool show_speed: true
        property bool show_heading: true
        property bool show_altitude_second: true
        property bool show_arrow: true
        property bool show_map: true
        property bool show_throttle: true
    }

    OpenHDRC {
        id: openHDRC
    }

    QOpenHDLink {
        id: link
    }

    OpenHDSettings {
        id: openHDSettings
    }

    Connections {
        target: openHDSettings
        onGroundStationIPUpdated: {
            link.setGroundIP(address)
            openHDRC.setGroundIP(address)
            mavlinkTelemetry.setGroundIP(address)
        }
    }

    Connections {
        target: link

        onSettingChangedBool: {
            //settings.setValue(setting, value)
            switch (setting) {
            case "show_downlink_rssi":
            settings.show_downlink_rssi = value;
            break;
            case "show_uplink_rssi":
            settings.show_uplink_rssi = value;
            break;
            case "show_bitate":
            settings.show_bitrate = value;
            break;
            case "show_air_battery":
            settings.show_air_battery = value;
            break;
            case "show_gps":
            settings.show_gps = value;
            break;
            case "show_home_distance":
            settings.show_home_distance = value;
            break;
            case "show_flight_timer":
            settings.show_flight_timer = value;
            break;
            case "show_flight_mode":
            settings.show_flight_mode = value;
            break;
            case "show_ground_status":
            settings.show_ground_status = value;
            break;
            case "show_air_status":
            settings.show_air_status = value;
            break;
            case "show_message_hud":
            settings.show_message_hud = value;
            break;
            case "show_horizon":
            settings.show_horizon = value;
            break;
            case "show_fpv":
            settings.show_fpv = value;
            break;
            case "show_altitude":
            settings.show_altitude = value;
            break;
            case "show_speed":
            settings.show_speed = value;
            break;
            case "show_heading":
            settings.show_heading = value;
            break;
            case "show_altitude_second":
            settings.show_altitude_second = value;
            break;
            case "show_arrow":
            settings.show_arrow = value;
            break;
            case "show_map":
            settings.show_map = value;
            break;
            case "show_throttle":
            settings.show_throttle = value;
            break;
            case "show_pip_video":
                    settings.show_pip_video = value;
                    break;
            default:
            break;
            }
        }

        onSettingChangedNumber: {
            switch (setting) {
                case "battery_cells":
                    settings.battery_cells = value;
                    break;
                default:
                    break;
            }
        }

        onAllSettingsChanged: {
            console.log("onAllSettingsChanged");

            var _settingsModel = link.allSettings;

            for (var setting in _settingsModel) {
                console.log("received " + setting + " value");
                var value = _settingsModel[setting];

                switch (setting) {
                case "show_downlink_rssi":
                    settings.show_downlink_rssi = value;
                    break;
                case "show_uplink_rssi":
                    settings.show_uplink_rssi = value;
                    break;
                case "show_bitate":
                    settings.show_bitrate = value;
                    break;
                case "show_air_battery":
                    settings.show_air_battery = value;
                    break;
                case "show_gps":
                    settings.show_gps = value;
                    break;
                case "show_home_distance":
                    settings.show_home_distance = value;
                    break;
                case "show_flight_timer":
                    settings.show_flight_timer = value;
                    break;
                case "show_flight_mode":
                    settings.show_flight_mode = value;
                    break;
                case "show_ground_status":
                    settings.show_ground_status = value;
                    break;
                case "show_air_status":
                    settings.show_air_status = value;
                    break;
                case "show_message_hud":
                    settings.show_message_hud = value;
                    break;
                case "show_horizon":
                    settings.show_horizon = value;
                    break;
                case "show_fpv":
                    settings.show_fpv = value;
                    break;
                case "show_altitude":
                    settings.show_altitude = value;
                    break;
                case "show_speed":
                    settings.show_speed = value;
                    break;
                case "show_heading":
                    settings.show_heading = value;
                    break;
                case "show_altitude_second":
                    settings.show_altitude_second = value;
                    break;
                case "show_arrow":
                    settings.show_arrow = value;
                    break;
                case "show_map":
                    settings.show_map = value;
                    break;
                case "show_throttle":
                    settings.show_throttle = value;
                    break;
                case "battery_cells":
                    settings.battery_cells = value;
                    break;
                case "show_pip_video":
                    settings.show_pip_video = value;
                    break;
                default:
                    break;
                }
            }
        }
    }

    function syncSettings() {
        var sync = {};

        sync['battery_cells'] = settings.battery_cells
        sync['show_pip_video'] = settings.show_pip_video

        sync['enable_imperial'] = settings.enable_imperial

        // never sync these
        //sync['enable_software_video_decoder'] = settings.enable_software_video_decoder
        //sync['enable_speech'] = settings.enable_speech
        //sync['enable_rc'] = settings.enable_rc


        sync['show_downlink_rssi'] = settings.show_downlink_rssi
        sync['show_uplink_rssi'] = settings.show_uplink_rssi
        sync['show_bitrate'] = settings.show_bitrate
        sync['show_air_battery'] = settings.show_air_battery
        sync['show_gps'] = settings.show_gps
        sync['show_home_distance'] = settings.show_home_distance
        sync['show_flight_timer'] = settings.show_flight_timer
        sync['show_flight_mode'] = settings.show_flight_mode
        sync['show_ground_status'] = settings.show_ground_status
        sync['show_air_status'] = settings.show_air_status
        sync['show_message_hud'] = settings.show_message_hud
        sync['show_horizon'] = settings.show_horizon
        sync['show_fpv'] = settings.show_fpv
        sync['show_altitude'] = settings.show_altitude
        sync['show_speed'] = settings.show_speed
        sync['show_heading'] = settings.show_heading
        sync['show_altitude_second'] = settings.show_altitude_second
        sync['show_arrow'] = settings.show_arrow
        sync['show_map'] = settings.show_map
        sync['show_throttle'] = settings.show_throttle
    }

    OpenHDTelemetry {
        id: openHDTelemetry
    }

    MavlinkTelemetry {
        id: mavlinkTelemetry
    }

    //FrSkyTelemetry {
    //    id: frskyTelemetry
    //}

    //MSPTelemetry {
    //    id: mspTelemetry
    //}

    //LTMTelemetry {
    //    id: ltmTelemetry
    //}

    Loader {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        z: 1.0
        source: EnableMainVideo ? "MainVideoItem.qml" : ""
    }

    Connections {
        target: OpenHD
        onMessageReceived: {
            hudOverlayGrid.messageHUD.pushMessage(message, level)
        }
    }

    Connections {
        target: LocalMessage
        onMessageReceived: {
            hudOverlayGrid.messageHUD.pushMessage(message, level)
        }
    }

    // UI areas

    UpperOverlayBar {
        id: upperOverlayBar
        onSettingsButtonClicked: {
            settings_panel.openSettings();
        }
    }

    HUDOverlayGrid {
        id: hudOverlayGrid
        anchors.fill: parent
        z: 3.0
    }

    LowerOverlayBar {
        id: lowerOverlayBar
    }


    SettingsPopup {
        id: settings_panel
        onLocalMessage: {
            hudOverlayGrid.messageHUD.pushMessage(message, level)
        }
    }
}

/*##^##
Designer {
    D{i:6;anchors_y:8}D{i:7;anchors_y:32}D{i:8;anchors_y:32}D{i:9;anchors_y:8}D{i:10;anchors_y:32}
D{i:11;anchors_y:32}D{i:12;anchors_y:11}D{i:13;anchors_y:11}D{i:14;anchors_x:62}D{i:15;anchors_x:128}
D{i:16;anchors_x:136;anchors_y:11}D{i:17;anchors_x:82;anchors_y:8}D{i:19;anchors_y:8}
D{i:21;anchors_y:31}D{i:22;anchors_y:8}D{i:23;anchors_y:11}D{i:24;anchors_y:32}
}
##^##*/
