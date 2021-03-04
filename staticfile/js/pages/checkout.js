$("#id_city").addClass('id_city')

$("#id_region").change(function () {
    var url = $("#personForm").attr("data-cities-url");  // get the url of the `load_cities` view
    var regionId = $(this).val();  // get the selected region ID from the HTML input

    $.ajax({                       // initialize an AJAX request
        url: url,                    // set the url of the request (= localhost:8000/hr/ajax/load-cities/)
        data: {
            'region': regionId       // add the region id to the GET parameters
        },
        success: function (data) {   // `data` is the return of the `load_cities` view function
            $("#id_city").html(data);

        }
    });

});
$("#id_address").width("450px");
$("#id_address").height("10px");






// save order

$('#personForm').submit(function (e) {
   
    if ($.trim($("#id_name").val()) === "" || $.trim($("#id_address").val()) === "" || $.trim($("#id_phone_number").val()) === "" || $.trim($("#id_region").val()) === "" || $.trim($("#id_city").val()) === "") {
        alert('all fields are required');
        return false;
    }
        else {
            e.preventDefault();
            $.ajax({
                type: 'POST',
                url: '/checkout/',

                data: {

                    name: $('#id_name').val(),
                    email: $('#id_email').val(),
                    address: $('#id_address').val(),
                    phone_number: $('#id_phone_number').val(),
                    address: $('#id_address').val(),
                    region: $('#id_region').val(),
                    city: $('#id_city').val(),
                    demo:$('#demo').val(),
                    
                    csrfmiddlewaretoken: $('input[name=csrfmiddlewaretoken]').val(),

                },
                beforeSend: function () {
                    console.log('sending data')
                    // getLocation()
                    $("save_checkout").text("Submiting Your Orders").addClass('icon-spinner')
                },

                success: function () {
                    $("save_checkout").text("Submiting Your Orders").addClass('icon-check')
                    console.log('saved')
                    var url = '/checkout_success/'
                    $(location).attr('href', url)
                
                },
                error: function () {
                    alert('error no saved try again')

                }

            })
        }
  
});


// $('#personForm').on('submit', function (e) {

//     e.preventDefault();



// })


// getting geolocation
var x = document.getElementById("demo");

function getLocation() {
  
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition, showError);
    } else {
        x.innerHTML = "Geolocation is not supported by this browser.";
        // window.location ='/checkout_success/'
        var url = '/checkout_success/'
        $(location).attr('href', url)

    }
}

function showPosition(position) {
    x.value = "Latitude: " + position.coords.latitude +
        "<br>Longitude: " + position.coords.longitude;
        // window.location ='/checkout_success/'
        var url = '/checkout_success/'
        $(location).attr('href', url)


}

function showError(error) {
    switch (error.code) {
        case error.PERMISSION_DENIED:
            x.value = "User denied the request for Geolocation."   
            var url = '/checkout_success/'
            $(location).attr('href', url)
            //  window.location ='/checkout_success/'

            break;
        case error.POSITION_UNAVAILABLE:
            x.value = "Location information is unavailable."
            var url = '/checkout_success/'
            $(location).attr('href', url)
            // window.location ='/checkout_success/'

            break;
        case error.TIMEOUT:
            x.value = "The request to get user location timed out."
            var url = '/checkout_success/'
            $(location).attr('href', url)
            // window.location ='/checkout_success/'

            break;
        case error.UNKNOWN_ERROR:
            x.value = "An unknown error occurred."
            var url = '/checkout_success/'
            $(location).attr('href', url)
            // window.location ='/checkout_success/'

            break;
    }

}