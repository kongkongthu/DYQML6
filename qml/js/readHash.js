function readHashData(hashKeys) {
    if(typeof(hashKeys)==="object")
        return _readHashDataList();
    else if(typeof(hashKeys === "string")){
        if(hashKeys === "")
            return "---";
        else
            return _readSingleData(hashKeys);
    }
}

function _readSingleData(hashKey){return backend.getHashData(hashKey);}

function _readHashDataList(hashKeys){return backend.getHashDataList(hashKeys);}

////////////////////////////////////////////////

function readHashDataItem(hashKeys, itemName){
    if(itemName){
        if(typeof(hashKeys) === "object")
            _readHashDataItemList(hashKeys, itemName);
        else if(typeof(hashKeys === "string")){
            if(hashKeys === "")
                return "---";
            else
                return _readSingleDataItem(hashKeys, itemName);
        }
    }
}

function _readSingleDataItem(hashKey, itemName){return backend.getHashDataItem(hashKey, itemName);}

function _readHashDataItemList(hashKeys, itemName){
    let dataArray=[];
    for(let i=0; i<hashKeys.length; i++)
        dataArray[i] = _readSingleDataItem(hashKeys[i], itemName);
    return dataArray;
}


/////////////////////////////////////////////////

function readHashDataObj(hashKeys){
    if(typeof(hashKeys)==="object")
        return _readMutilDataObj(hashKeys);
    else if(typeof(hashKeys)==="string"){
        if(hashKeys==="")
            return "---";
        else
            return _readSingleDataObj(hashKeys)
    }
}

function _readMutilDataObj(hashKeys){return backend.getHashDataObj(hashKeys);}

function _readSingleDataObj(hashKey){
    let hashKeys =[];
    hashKeys[0] = hashKey;
    return backend.getHashDataObj(hashKeys);
}


