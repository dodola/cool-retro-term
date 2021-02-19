import QtQuick 2.2
import QtGraphicalEffects 1.0

import "utils.js" as Utils

ShaderTerminal {
    property alias title: terminal.title
    property alias terminalSize: terminal.terminalSize

    id: mainShader
    opacity: appSettings.windowOpacity * 0.3 + 0.7

    source: terminal.mainSource
    burnInEffect: terminal.burnInEffect
    slowBurnInEffect: terminal.slowBurnInEffect
    virtual_resolution: terminal.virtualResolution

    TimeManager{
        id: timeManager
        enableTimer: terminalWindow.visible
    }

    PreprocessedTerminal{
        id: terminal
        anchors.fill: parent
    }
    function updateActivity(){
        terminal.updateActivity();
    }


    //  EFFECTS  ////////////////////////////////////////////////////////////////

    Loader{
        id: bloomEffectLoader
        active: appSettings.bloom
        asynchronous: true
        width: parent.width * appSettings.bloomQuality
        height: parent.height * appSettings.bloomQuality

        sourceComponent: FastBlur{
            radius: Utils.lint(16, 64, appSettings.bloomQuality);
            source: terminal.mainSource
            transparentBorder: true
        }
    }
    Loader{
        id: bloomSourceLoader
        active: appSettings.bloom !== 0
        asynchronous: true
        sourceComponent: ShaderEffectSource{
            id: _bloomEffectSource
            sourceItem: bloomEffectLoader.item
            hideSource: true
            smooth: true
            visible: false
        }
    }

    bloomSource: bloomSourceLoader.item

}
