function loginButtonClicked() {
    var emailInput = $("#email-input");
    var passwordInput = $("#password-input");
    var email = emailInput.val();
    var password = passwordInput.val();

    if (!email || email.length == 0 || !password || password.length == 0) {
        alert("Въведете валидни потребителско име и парола!");
        return;
    }

    password = Sha1.hash(password);

    var that = this;

    var successHandler = function() {
        hideLoginButtons();
        window.location.reload();
    }

    var errorHandler = function() {
        alert("Нещо се обърка. Може би сте сбъркали мейла или паролата?");
    }

    $.ajax({
        type: "POST",
        url: LOGIN_ENDPOINT,
        data: JSON.stringify({email: email, password: password}),
        contentType: 'application/json',
        success: successHandler,
        error: errorHandler,
        xhrFields: {
            withCredentials: true
        }
    })
}

function logoutButtonClicked() {
    var successHandler = function() {
        showLoginButtons();
        window.location.reload();
    }

    var errorHandler = function() {
        alert("Нещо се обърка :(");
    }

    $.ajax({
        type: "POST",
        url: LOGOUT_ENDPOINT,
        contentType: 'application/json',
        success: successHandler,
        error: errorHandler,
        xhrFields: {
            withCredentials: true
        }
    })

    showLoginButtons();
}

function hideLoginButtons() {
    $("#email-input").hide();
    $("#password-input").hide();
    $("#login-button").hide();
    $("#logout-button").show();
}

function showLoginButtons() {
    $("#email-input").show();
    $("#password-input").show();
    $("#login-button").show();
    $("#logout-button").hide();
}

function modifyButtonClicked(id) {
    document.location = '/edit/'+ id;
}

function addButtonClicked(id) {
    document.location = '/add/';
}

function deleteButtonClicked(id) {
    var successHandler = function() {
        window.location.reload();
    }

    var errorHandler = function() {
        alert("Нещо се обърка :(");
    }

    $.ajax({
        type: "DELETE",
        url: GET_DELETE_ENDPOINT(id),
        success: successHandler,
        error: errorHandler,
        xhrFields: {
            withCredentials: true
        }
    })
}

function updateObject() {
    var idInput = $("#id-input").val();
    var nameInput = $("#name-input").val();
    var latInput = $("#lat-input").val();
    var lngInput = $("#lng-input").val();
    var altInput = $("#alt-input").val();
    var k = $("#type-input");
    var typeInput = $("#type-input").val();
    var descriptionInput = $("#description-input").val();

    // TODO: Strip spaces!
    if (!nameInput || !latInput || !lngInput) {
        alert("Полетата за име, ширина, дължина и надморска височина са задължителни!")
        return;
    }

    var data = {
        name: nameInput,
        lat: latInput,
        lng: lngInput,
        alt: altInput,
        description: descriptionInput
    };

    var existingOne;
    if (idInput) {
        existingOne = true;
        data.id = idInput
    } else {
        existingOne = false;
        data.type = typeInput;
    }

    var successHandler = function() {
        document.location = "/list/";
    }

    var errorHandler = function() {
        alert("Нещо се обърка :(");
    }

    $.ajax({
        type: existingOne ? "POST" : "PUT",
        url: existingOne ? GET_EDIT_ENDPOINT(idInput) : ADD_ENDPOINT,
        data: JSON.stringify(data),
        contentType: 'application/json',
        success: successHandler,
        error: errorHandler,
        xhrFields: {
            withCredentials: true
        }
    })
}