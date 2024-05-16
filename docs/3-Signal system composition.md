# Signal system composition

[TOC]

## I. Overview

One of the major features of Qt is that it has a strong and stable signaling system. QML, like `QWidgets`, has even more flexible signal and slot mechanisms. However, too flexible signals are usually confusing, not good will lead to the program's signals with the development of the depth of the more and more chaotic,.for the developers who have just begun to use Qt, which is often more painful. If the project lacks effective management, you have to go along with them to find their ins and outs, and that feeling is self-evident.

For this reason, DYQML has a reasonable and strong specification for the signaling system of the whole project, and all signals are distributed through this signaling system, so that the signaling system can work in a clear and organized way. Using DYQML to configure their own projects, should understand its signaling system. On the basis of the signaling system, we can complete almost all the business logic by configuring the configuration file.

## II. Signal and signal emission

### 2.1 The signaling body `dSignal`

The information passed in DYQML's signaling system is standardized using a unified signal structure, and we define the specific content of the information as the signal body `dSignal.` The following is the data structure of `dSignal`:

```json
{
    sigId: "your-signal-id", // Essential
    destCode: "100", //Non essential
    subInfo: {}, //Non essential
}
```

Among them, **sigId** is essential, which is an identifier of a signal. In the entire DYQML system, all dynamically generated controls recognize this identifier and respond to the corresponding signal. The `dSignal` is a basic property of the `DControllerBase` component, so controls inherited from it have this property, and through custom development, users can configure the corresponding `dSignal` in configurations file. 

```qml
// DControllerBase.qml

import QtQuick 2.15

DObject {
    id: controllerBase
    dyType: "controller"
    property var crtInfo:({})
    property var dSignal:({"sigId":"", "destCode":"100", "subInfo":{}})
    property string fieldName
    property var fieldInfo: ({})
}
```

### 2.2 Three Signals

In DYQML, all signal emissions are completed through three signals defined in `Main.qml`, which are:

- `sigTriggerGUI(var dSignal)`: A signal used to trigger the interface response.
- `sigTriggerConfirm(var dSignal)`: A signal used to trigger a secondary confirmation before sending to the backend C++.
- `sigTriggerBackEnd(var dSignal)`: A signal used to send to the backend C++.

In fact, we do not need to manually invoke these three signals. DYQML defines a signal dispatcher, which is the `emitSignal()` function defined in `procEmitSignal.js` under the js directory. This function will parse the `dSignal` and then decide which of the three signals mentioned above to send the `dSignal` through. We can consider this function as the central signal dispatcher of the DYQML system. We only need to include the js file and call this function when we need to emit a signal. The following code is an example of calling the signal dispatcher when a `DYSwitch` is triggered:

```js
//DYSwitch.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import "./../js/procEmitSignal.js" as EmitSignal //import signal dispatcher

DControllerBase {
    id: dySwitch
    ...
    Connections{
        target: control
        function onCheckedChanged() {
            verifyTextPos();
            formFieldInfo();
            emitSwitchStatus();
        }
    }

    function emitSwitchStatus(){
        if(sigId){
            if(control.checked)
                dSignal["sigId"] = sigId + "-ON";
            else
                dSignal["sigId"] = sigId + "-OFF";
            EmitSignal.emitSignal(dSignal); //call signal dispatcher
        }
    }
    ...
}
```

### 2.3 Detailed Explanation of the Signal Dispatcher

The signal dispatcher's `emitSignal()` function can determine how to dispatch a signal based on the information contained within `dSignal`, which is determined by the `destCode` field within `dSignal`. We can consider that, for any signal emitted within the system, we have already identified the default recipient of that signal before it is sent. We know who we expect to receive the signal and respond to it once it is emitted. The signal system in DYQML ensures that `dSignal` includes the basic destination information `destCode`, and this, along with other signal information, is transmitted. Let's take another look at the basic data structure of `dSignal`:

```json
{
    sigId: "your-signal-id", // Essential
    destCode: "100", //Non essential
    subInfo: {}, //Non essential
}
```

For a `dSignal` signal object, only the `sigId` is mandatory. As long as there is a `sigId`, the signal body can be dispatched through the signal dispatcher. `subInfo` is additional data attached to the signal body; you can add any data you want and send it along. It is crucial to understand the encoding meaning of `destCode`. `destCode` stands for destination code, and the signal dispatcher uses `destCode` to distribute the signal. As previously mentioned, DYQML signal dispatching is divided into three types, each for sending signals to the interface, secondary confirmation controls, and the C++ backend. These three can be considered as the signal's destinations.
The `destCode` is a string composed of three characters, each representing a destination. A '0' indicates that the signal is not sent to that destination, while a '1' indicates that the signal is sent to that destination. For example, "100" means the signal is sent only to the GUI interface and not to the secondary confirmation controls or the C++ backend. "101" means the signal is sent both to the GUI and to the C++ backend, and so on. If `destCode` is not set, it defaults to "100", which sends the signal to the interface.

![destCodeDefinition](3-Signal%20system%20composition.assets/destCodeDefinition.jpg)

Since all controls that inherit from `DControllerBase` have the `dSignal` property by default, we can configure `dSignal` in the configuration file and load it into the program. Taking the following figure as an example, the control is configured with a signal named "SWITCH-TO-SPECIFIED-FONT-FAMILY", and the `subInfo` is added with the `fontFamily` information set to `Microsoft YaHei`. This `sigId` is a system preset ID, and with it and the font information in `subInfo`, you can switch the font family used throughout the entire interface. You can specify your own `sigId` to trigger your own event responses. In the appendix of this article, the system preset `sigId`s are introduced, which everyone can utilize.

![1714990275164](3-Signal%20system%20composition.assets/1714990275164.png)

### 2.4 C++ Backend Signaling to the Interface

The general purpose of the C++ backend sending signals to the interface is to trigger reactions and actions on the interface. Currently, the C++ backend sends signals to the frontend through the same signal mechanism. The specific method of invocation is defined within the C++ `QmlInterface` class, which is an interface class facing to QML. Through its instantiated object, the backend can send the desired `dSignal` to the interface by calling the `triggerQML()` method.

```c++
public:
    void triggerQML(QVariantMap dSignal);
```

The structure of `dSignal` here is exactly the same as previously mentioned. In the C++ backend, it is a `QVariantMap` type of data. `QVariantMap` type data will automatically be converted into JSON format when passed to QML, which is very convenient to use.

## III. Signal Reception

The signals emitted are the three types mentioned above, each sent to three different destinations—the interface, the secondary confirmation controls on the interface, and the C++ backend. DYQML further simplifies the reception of signals by unifying the signals sent to the interface and those sent to the secondary confirmation controls into signals sent to the frontend. So apart from specific controls on the interface, only the signals sent to the frontend need to be responded to.

### 3.1 Reception of Signals Sent to the Frontend

The reception of frontend signals is defined within each dynamically generated control. Taking `DObject` as an example:

```js
Connections{
    target: frontEnd
    function onSigTriggerFrontEnd (dSignal){
        procStatusOnSignal(dSignal);
        postProcStatusOnSignal(dSignal);
    }
}
```

Using `Connections`, set the target to `frontEnd`, which is the `id` of `Main.qml`, and then use a response slot function to respond to the corresponding signal and perform the appropriate processing.

### 3.2 Reception of Signals Sent to the Backend

The C++ backend is responsible for receiving signals sent to the backend. This is done through the `DYBackEnd` object `backend` instantiated in main.cpp, which receives signals. In `Main.qml`, the `dSignal` is sent to the backend by calling the `receiveFromQml()` function of `backend`. After that, it is the responsibility of the developer in charge of the backend C++ to handle the response of this function. Currently, the `backend` object of DYQML is only responsible for receiving signal data and does not perform any processing. It is recommended that the relevant developers first define a `dSignal` parser to handle different responses by parsing the `dSignal`.

```qml
// Main.qml
function onSigTriggerFrontEnd(dSignal){
    function onSigTriggerBackEnd(dSignal){
    	console.log(`signal trigger backend, and dSignal = ${
    		JSON.stringify(dSignal)
    	}`);
    	backend.receiveFromQml(dSignal); //call C++ function receiveFormQml()
    }
}
```

## Attachment: system preset `sigId`

Currently the system only presets two signal ids, they are:

- “SWITCH-TO-SPECIFIED-FONT-FAMILY”: used to switch the interface font
- “SET-COLORSPACE”: used to set the color space, the specific color information is set in the `subInfo`, about the specific color space including which basic color attributes, you can see `DYColorSpace.qml`

```qml
// DYColorSpace.qml
QtObject{
    property string brandColor: "#177ddc"
    property string darkerTransBrandColor: "#a0177ddc"
    property string semiTransBrandColor: "#80177ddc"
    property string lighterTransBrandColor: "#50177ddc"
    property string primaryColor: "#333"
    property string secondaryColor: "#555"
    property string lightColor: "#777"
    property string lighterColor: "#999"
    property string successColor: "#67c23a"
    property string warningColor: "#e6a23c"
    property string dangerColor: "#f56c6c"
    property string semiTransSuccessColor: "#8067c23a"
    property string semiTransWarningColor: "#80e6a23c"
    property string semiTransDangerColor: "#80f56c6c"
    property string primaryFontColor: "#fff"
    property string regularFontColor: "#dcdcdc"
    property string secondaryFontColor: "#ccc"
    property string placeholderFontColor: "#aaa"
    property string baseBorderColor: "#ccc"
    property string lightBorderColor: "#bbb"
    property string lighterBorderColor: "#aaa"
    property string extraBorderColor: "#999"
    property string backgroundColor: "#333"
    property string lightBackgroundColor: "#444"
    property string lighterBackgroundColor: "#555"
    property string primaryDisableColor: "#777"
    property string secondaryDisableColor: "#999"
    property string fullTransparentColor: "#00000000"
    property string halfTransparentColor: "#50000000"
}
```

