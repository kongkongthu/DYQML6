function emitSignal(dSignal) {
    if(dSignal && dSignal.sigId){
        console.log(`emitting: dSignal = ${JSON.stringify(dSignal)}`)
        let destCode = dSignal.destCode;
        if(!destCode)
            frontEnd.sigTriggerGUI(dSignal);
        else{
            if(typeof(destCode) === "number")
                destCode = Math.floor(Math.abs(destCode)).toString();
            if(destCode[0]==="1")
                frontEnd.sigTriggerGUI(dSignal);
            if(destCode[1]==="1")
                frontEnd.sigTriggerConfirm(dSignal);
            if(destCode[2]==="1")
                frontEnd.sigTriggerBackEnd(dSignal);
        }
    }
    else if(dSignal && !dSignal.sigId){
        console.log(`dSignal contains no sigId, will block the emission,
                    and dSignal = ${JSON.stringify(dSignal)}`)
    }
    else
        console.log(`dSignal is empty, do nothing and do not emit the signal`);
}
