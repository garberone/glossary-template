/**
 * This function check the live properties and clear the interval if the live is up to date
 */
function waitForLive() {
    var onLive = checkLive();
    if (onLive) {
        clearInterval(intervalValue);
    }
}

/**
 * This function makes an api call to check if the properties in live mode are updated
 */
function checkLive() {
    $.ajax({
        type: "GET",
        url: readUrl,
        async: false,
        success: function (result) {
            return ($('#pathTxt').val() == result.properties.pathTxt.value);
        }
    });
    return false;
}

/**
 * This function create or update the twitter settings JCR nodes with the access settings from the form
 * @param intervalValue
 */
function createUpdateGlossaryParameters(intervalValue) {
    //getting the good Json form
    var jsonData;
    if (mode == 'create') {
        jsonData = "{\"children\":{\"glossarySettings\":{\"name\":\"glossarySettings\",\"type\":\"glsnt:glossaryAdministration\",\"properties\":{\"pathTxt\":{\"value\":\"" + $('#dictionaryPathTxt').val() + "\"}}}}}";
    }
    else {
        jsonData = "{\"properties\":{\"pathTxt\":{\"value\":\"" + $('#dictionaryPathTxt').val()  + "\"}}}";
    }
    //Calling API to update JCR
    $.ajax({
        contentType: 'application/json',
        data: jsonData,
        dataType: 'json',
        processData: false,
        async: false,
        type: 'PUT',
        url: writeUrl,
        success: function (result) {
            //check live values every 0.5 sec untill they are up to date
            intervalValue = setInterval(waitForLive(), 500);
            window.location.reload();
        }
    });
}

/**
 * Reset form fields
 */
function resetGlossarySettings() {
    $('#dictionaryPathTxt').val(jcrPathTxt);
    $('#saveGlossarySettings').attr("disabled", "disabled");
    $('#cancelGlossarySettings').attr("disabled", "disabled");
}

/**
 * Validates to enable the save/cancel button
 */
function validateGlossaryForm(jqField,jcrKey){

    if (  ($('#dictionaryPathTxt').val() != "") &&  ($("#"+jqField).val() != jcrKey)){
        $('#saveGlossarySettings').removeAttr("disabled");
        $('#cancelGlossarySettings').removeAttr("disabled");
    } else {
        $('#saveGlossarySettings').attr("disabled", "disabled");
        $('#cancelGlossarySettings').attr("disabled", "disabled");
    }
}

/**
 * Add the keyup event listener to the form fields for validation purposes
 * */
$(document).ready(function () {
    /* insert code here */
});


