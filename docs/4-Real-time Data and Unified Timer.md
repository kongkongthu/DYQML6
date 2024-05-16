# Real-time Data and Unified Timer

[TOC]

For real-time update of data it is recommended to use DYQML's real-time data system , and through the frontend definition of a unified timer `freshTimer`, in the need for real-time data display of the control to obtain data regularly and refresh the interface display. Using this real-time data display system can standardize the interface data update, better and simpler maintenance of data, so that the maintenance of data update and display refresh more efficient.

## I. Real-time data system and structure of real-time data

### 1.1 Hash table and method definition

The core of the real-time data system is to manage the data through the hash table, which is defined in the C++ `DYBackEND` class as one of its private variables, and at the same time opens up four interface functions for QML to read the data from the hash table:

```c++
Q_INVOKABLE QVariant getHashDataObj(QStringList dataIdList);
Q_INVOKABLE QVariantList getHashDataList(QStringList dataIdList);
Q_INVOKABLE QVariant getHashData(QString dataId);
Q_INVOKABLE QVariant getHashDataItem(QString dataId, QString itemName);
```

In practice, we do not need to use them directly , because in the QML side , in the js directory `readHash.js` file defines the four interface functions for the above call method. QML controls only need to import this js file and call the one of the 3 methods. `readHash.js` defines the main methods include:

```js
// readHash.js
// Read the values corresponding to multiple key values in the hash table, 
// return a list of values, where each value is a JSON object. If there is
// only one key, then only the corresponding value's JSON object is returned.
function readHashData(hashKeys)

// Read the values corresponding to multiple key values from the hash table, 
// and extract the data for the corresponding itemName field from each value.
// Form a list with these data and return it. If there is only one key, then 
// only return the data for the itemName field corresponding to that key from
// the hash table
function readHashDataItem(hashKeys, itemName)

// Similar to the `readHashData()` method, but instead of returning a JSON 
// list, it returns a JSON object with the key as the key.
function readHashDataObj(hashKeys)
```

The above three methods support reading multiple hash keys at a time, also support reading only one key, you can use the above three methods as needed.

### 1.2 key, dataId and GUID

The key here is the `dataId` defined by C++, please make sure they are unique within the hash table. The whole DYQML system manages and accesses each data in the hash table through `dataId`. If the amount of data is huge, for example more than 100 items, it is recommended to use global unique identifier GUID to ensure uniqueness. There are many software and tools that can generate GUIDs, and unified management of the generated GUIDs will greatly simplify your project.

The format of GUID is "`xxxxxxxxxx-xxxx-xxxx-xxxxxx-xxxxxxxxxxxxx`", where each x is a [hexadecimal] data in the range 0-9 or a-f. For example: `TY961D5F-8B7T-YUH8-BB5T-T5TI6VB9S5NL`. Some software generates letters all in upper case, some in lower case, both are fine and do not affect the use.

## II. The C++ backend maintains the hash table

The C++ backend is responsible for maintaining this hash table, pushing the data you need into the hash table and maintaining the data updates. The method of maintaining the hash table can be referred to `C++/fakeFunction/genfakehashdata.cpp`. This is a class that generates fake data for the hash table, which allows the QML interface to obtain dynamically changing fake data. The data in the actual project should come from the actual data source, such as the network, the data collection device, the collection card, etc. The following is the code of genfakehashdata.cpp to generate and update the hash table:

```c++
#include "genfakehashdata.h"

GenFakeHashData::GenFakeHashData(QHash<QString, QVariantMap> *dyHash, QObject *parent)
{
    this->_dyHash = dyHash;
}

void GenFakeHashData::startGenData()
{
    this->_genTimer = new QTimer(this);
    this->connect(this->_genTimer, SIGNAL(timeout()), this, SLOT(gengerating()));
    this->_genTimer->start(200);
}

void GenFakeHashData::gengerating()
{
    QString rawDataId = "fake-data-guid";
    QString dataId;
    QString valueName;
    QString unit = "m";
    double value;
    QVariantMap dataInfo;

    for (int i = 0; i < 100; ++i) {
        dataId = rawDataId + QString::number(i);
        valueName = "VName" + QString::number(i);
        if(i % 4 == 1)
            unit = "cm";
        else if(i % 4 == 2)
            unit = "º";
        else if(i % 4 == 3)
            unit = "℃";
        value = QRandomGenerator::global()->bounded(100.00);
        dataInfo["name"] = valueName;
        dataInfo["value"] = value;
        dataInfo["unit"] = unit;
        if(_dyHash->contains(dataId))
            _dyHash->remove(dataId);
        _dyHash->insert(dataId, dataInfo);
    }
}

```

Currently in the hash table data, contains only three kinds of information, namely, “name”, “value”, “unit” (here the value refers to the actual data values, rather than the hash table key-value pairs mentioned above, the hash table value is a proprietary concept corresponding to the key, do not confuse). When using, it should be noted that each time the hash table is updated, the original key-value pairs need to be deleted; otherwise, the Qt hash table will not automatically delete the old data, which can ultimately lead to a memory overflow. So focus on the following three statements:

```c++
if(_dyHash->contains(dataId))
    _dyHash->remove(dataId);
_dyHash->insert(dataId, dataInfo);
```

## III. Unified Timer and getting data

### 3.1 Unified Timer `freshTimer`

Before using it, the developer needs to understand DYQML's concept of real-time data. In DYQML's view, the focus of real-time data is on the real-time nature of the data, which is reflected in several aspects: 1. The current state of the system is the most important, and the program should prioritize the display of the latest data; 2. Users don't care about the historical data, and the importance of the current data is much greater than that of the historical data; 3. The interface is user oriented, and the backend is data oriented.

The unified timer `freshTimer` is defined in `Main.qml`, all the real-time data updates on the interface are triggered by this unified timer. The current period of the unified timer is 200ms, which allows the interface to update data five times a second. This time interval is relatively reasonable, too slow users will feel lag, too fast human eyes can not follow, and will consume more resources. `freshTimer` definition is as follows:

```qml
Timer {
    id: freshTimer
    running: true
    repeat: true
    interval: 200
}
```

The C++ backend may update real-time data in the hash table at a frequency that differs from the frequency of the `freshTimer`. In some systems, the backend data update frequency may be much higher than 5Hz at 200ms, but in line with the aforementioned philosophy, the backend is separate from the interface. The interface uses its own frequency to update data. The advantage of this approach is that no matter how high the frequency of the backend data updates, it will not affect the display of the interface. This ensures the stability and comfort of the interface while also guaranteeing the real-time nature and high performance of the system. The C++ backend can store data in a data file or database to ensure the integrity of historical data, enabling traceability of the data. However, these are all tasks performed by the C++ backend and are unrelated to the interface display.

### 3.2 Interface Data Display and Update

Since DYQML dynamically generates various controls, how do these controls know when and where to obtain what data? This actually involves three questions: 1. When to obtain data; 2. Where to obtain data; 3. Which specific data or pieces of data to obtain. The first question has already been addressed earlier, which is to obtain data when the `freshTimer` cycle arrives and triggers a signal. The second question has also been resolved by using the three methods defined in `readHash.js`, as mentioned earlier, to read data from the C++ back end's hash table. What remains to be addressed is the third question, the data to be obtained.

The biggest feature of the DYQML project is its ability to generate the user interface through configuration files, and it can also generate business logic. Each control that is dynamically generated has all its necessary attributes completed by reading the configuration information in the configuration file, which includes information on what data to obtain. Taking the only data display control in the current program, `DYDataShower`, as an example, it has a property called `hashKeys`. This property is the `dataId` that `DYDataShower` uses to obtain data from the hash table. In the configuration file, we configure a specific `dataId` for a `DYDataShower`, so the control itself knows which data it needs to obtain:

![1714990590927](4-Real-time%20Data%20and%20Unified%20Timer.assets/1714990590927.png)

Here, it is important to emphasize another concept of DYQML designing controls, that is, each control is an independent entity, and each control is responsible for its own internal affairs, which also includes fetching data. That is, each control is responsible for fetching data from the hash table (via `readHash.js`) and for refreshing the interface display. 

In addition, it is strongly recommended that each data display control should judge the visible property of the control first, and the control should only fetch the data and refresh the display when visible is true, so as to optimize the system performance. Of course, some controls that can display historical data information, such as curve timing charts, need to get data all the time. The following is the code of `DYDataShower` to get the data:

```js
Connections {
        target: freshTimer
        function onTriggered(){
            if(visible) //When the control is visible, fetch the data
                processReadData();
        }
    }

    function processReadData(){
        if(firstTime)
            procFirstTime();
        else
            procOtherTimes();
    }

    function procFirstTime(){ //Get full information(unit, name and value) of a data for the first time, through function readHashData()
        firstTime = false;
        let jsonData;
        jsonData = ReadHash.readHashData(hashKeys);
        if(jsonData !== "None"){
            if(shower.name === "NoName")
                shower.name = jsonData.name;
            if(shower.unit === "")
                shower.unit = jsonData.unit;
            try{
                valueTxt.text = jsonData.value.toFixed(decimalNum);
            }catch(err){
                valueTxt.text = "---";
            }
        }
    }

    function procOtherTimes(){ //Get only the value of the data for other times through function readHashDataItem()
        let jsonData = ReadHash.readHashDataItem(hashKeys, "value")
        try{
            valueTxt.text = jsonData.toFixed(decimalNum);
        }catch(err){
            valueTxt.text = "---";
        }
    }
```

In the interface, when the unified timer is triggered periodically, it will send out a trigger signal to the whole interface, and all the controls that need to display data in real time will go to the C++ backend to get the data and refresh the interface display by themselves through `readHash.js` after receiving this signal. As an analogy, in DYQML system, the data showing controls are like ants moving to get their own data blocks.

## IV. Summary

The above describes DYQML's real-time data system and unified timer, and describes the method and process of getting data and updating the display of the control on the interface. Developers can develop their own controls according to the real-time data system, which are not limited to pure data display controls like `DYDateShower`, but can be all kinds of charts, all kinds of customized dynamic controls, or a table. For most controls that don't care about historical data, you should stop getting data and interface refresh when the control is not displaying. In the whole system, the C++ backend constantly maintains and updates the data in the hash table, and the QML interface controls are triggered by the `freshtimer` to fetch the corresponding data in the hash table and then update the interface display, thus accomplishing the continuous display of real-time data in the interface.
