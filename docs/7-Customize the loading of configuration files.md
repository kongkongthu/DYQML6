# Customize the loading of configuration files

[TOC]

Through the introduction before, we can master the basic structure of the configuration file, the basic configuration method, and understand the role and functionality of the configuration file. Through the configuration file, we can not only generate the program interface but also generate most of the business logic. Up to now, we have learned how to configure the configuration file, but we have not yet introduced how the configuration file is loaded. This article will address this issue. For special project requirements, developers can customize the loading process of the configuration file by modifying the relevant code.

## I. When need to customize the loading configuration file

We know that DYQML can use the Ctrl+O shortcut key to select and load the configuration file. We know that the program will load the JSON configuration file in the Default folder by default when it starts. We also know the application will reload the current configuration file at any time by pressing Ctrl+R. So when is it necessary to customize the loading of the configuration file? The situations that require custom loading of the configuration file are essentially those that wish to change the timing of the configuration file loading. The default loading timing of the program is the three mentioned above:

- When the Ctrl+O shortcut key is triggered  a configuration file is chosen.

- When a JSON configuration file is placed in the `Default` folder, and the program has just started.

- When the Ctrl+R shortcut key is triggered. 


However, some projects may want users to load the corresponding configuration file when different user events are triggered. For example, you have customized the main interface, and there is a list of car models on the main interface. You want users to load the configuration file corresponding to the car model when they click on different car models, thereby generating the interface and business logic unique to that model. At this time, users are selecting cars, and different cars correspond to different configuration files. Another example is that you need the Ctrl+O or Ctrl+R shortcut keys to trigger other event responses, but DYQML has occupied them, and you want to change this. These situations all require customizing the process of loading of the configuration file.

## II. Loading the Configuration File

### 2.1 `GUIFileLoader` Class

The function of loading configuration file in DYQML is completed by the `GUIFileLoader` class, which is defined in `/C++/guifileloader.h`. It exposes two methods and one signal to QML, and there is a public method `tryDefaultFile()`, which is used to load the configuration file in the Default folder:

```c++
public:
    // After the QML end selects the configuration file, call this function with the configuration file path as the parameter. After the program loads the configuration file, it will emit the following jsonHasRead signal.
    Q_INVOKABLE void jsonHasChosen(QString jsonPath);

    // After pressing Ctrl+R, QML will call this function, which is used to reload the currently selected configuration file. After the program is loaded, it will also emit the jsonHasRead signal.
    Q_INVOKABLE void reloadGUI();

    // Try to load the configuration file in the default folder.
    void tryDefaultFile();

signals:
    // Whenever the program has finished loading the configuration file, it will emit the following signal.
    QString jsonHasRead(QString jsonStr);
```

### 2.2 Three Ways to Load the Configuration File and Their Corresponding Processes

The following describes the processes for loading the configuration file in the three ways mentioned earlier: **The process for loading the configuration file in the Default folde**r:

- The program starts
- `main.cpp` instantiates `GUIFileLoader` as `fileLoader`
- main.cpp calls the `tryDefaultFile()` method of `fileLoader`
- If there is a configuration file in the `Default` folder, it is loaded (implementation of loading)
- `fileLoader` emits the `jsonHasRead` signal
- QML receives the signal and starts to create the interface 

**The process for loading the configuration file with Ctrl+O:**

- The user presses the `Ctrl+O` shortcut key

- A dialog box for selecting the configuration file pops up

- The user selects a certain configuration file

- QML calls the `jsonHasChosen()` method of the `fileLoader` object instantiated by `main.cpp`

- `fileLoader` loads the configuration file (implementation of loading)

- `fileLoader` emits the `jsonHasRead` signal

- QML receives the signal and starts to create the interface 

**The process for re-loading the configuration file with Ctrl+R:**

- The user presses the Ctrl+R shortcut key
- QML calls the `reloadGUI()` method of the `fileLoader` object instantiated by main.cpp
- `fileLoader` reloads the current configuration file (implementation of loading)
- `fileLoader` emits the `JSONHasRead` signal
- QML receives the signal and starts to create the interface 

The process of starting to load the JSON configuration file in the Default folder is completed in the C++ backend because it does not require the participation of QML. `fileLoader` will emit the` jsonHashRead()` signal after the loading is completed each time in each process situation.

### 2.3 Customizing the Loading Timing

The above describes the loading processes corresponding to the three supported loading methods for the configuration file in the current system. The loading is all implemented within the class `GuiFileLoader`, which is currently instantiated in `main.cpp`.

#### 2.3.1 Removing Shortcut Key Trigger

To remove the functionality corresponding to `Ctrl+O` and `Ctrl+R`, simply delete the corresponding shortcut key code in `Main.qml`:

```qml
// Main.qml
...
Shortcut{
    id: keyOfShowSelectPage
    context: Qt.ApplicationShortcut
    sequence: "Ctrl+O"
    onActivated: sigShowGUIChoosePage()
}
...
Shortcut{
    id: keyReloadGUI
    context: Qt.ApplicationShortcut
    sequence: "Ctrl+R"
    onActivated: fileLoader.reloadGUI()
}
...
```

#### 2.3.2 Triggering Loading by Other Means

For example, as mentioned at the beginning of this article, if we want users to select different configuration files by choosing different car models, such requirements are equivalent to using other user events to trigger the selection of the configuration file.

For such requirements, we first need the program to resolve the configuration file corresponding to different user events, that is, when the user makes different choices, the program needs to know the file path of the configuration file corresponding to different choices. This step is the most important and needs to be implemented by the developer. The correspondence between user choices and configuration file paths can be implemented in QML or in the C++ backend. There are various ways to implement this, such as having a mapping table that is hardcoded in the C++ backend or QML frontend, or writing this mapping table to a data file and loading it every time the program starts. This will not be elaborated one by one here, and developers can customize the implementation method according to product requirements.

After obtaining the configuration file path corresponding to the user event, whether in the QML end or in the C++ backend, you can call the `jsonHasChosen()` method of the `fileLoader` object. After that, everything is automatically completed. The `fileLoader` object will automatically load the configuration file and emit the `jsonHasRead()` signal after loading is completed, thus notifying QML to start dynamically generating the interface. 

So, in simple terms, it is two steps: 1. Obtain the configuration file path corresponding to the user event; 2. Call the `jsonHasChosen()` method of `fileLoader`.

## III. Summary

This article introduces the timing of loading the configuration file, the loading process of the three loading methods, and finally, how to customize the timing of loading the configuration file.
