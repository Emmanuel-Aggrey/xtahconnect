$("#id_city").addClass('id_city')

$("#id_region").change(function () {
    var url = $("#checkoutForm").attr("data-cities-url");  // get the url of the `load_cities` view
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
$("#id_address").height("5px");






// save order
var order_number
$('#checkoutForm').submit(function (e) {
   
  
    if ($.trim($("#id_name").val()) === "" || $.trim($("#id_address").val()) === "" || $.trim($("#id_phone_number").val()) === "" || $.trim($("#id_region").val()) === "" || $.trim($("#id_city").val()) === "" || $.trim($("#id_email").val()) === "" ) {
        // alert('all fields are required');
        toastError('all fields are required')
        // moveUp()

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
                    // order: $('#id_order').val(),
                    
                    csrfmiddlewaretoken: $('input[name=csrfmiddlewaretoken]').val(),

                },
                beforeSend: function () {
                    console.log('sending data')
                    // getLocation()
                    // $("#save_checkout").text("Submiting Your Orders").addClass('icon-spinner')
                    // toastSuccess('Submiting Your Order(s)')
                    // alert($('input[name="payment_method"]:checked').val(),)
                    // make_payments()
                 
                },

                success: function (response) {

                //   console.log('done',response.order_number)
                  order_number = response.order_number
                  moveUp()
                //    $("#checkoutForm").fadeOut('slow')
                $("#checkoutForm").remove()
                   $("#payment").fadeIn('slow')
                //    moveDown()
                  
                },
                error: function () {
                    // alert('error no saved try again')
                    // toastError('error not saved try again')

                }

            })
        }
  
});


// payment options
$("#payment").fadeOut()
$("#Submit_order").fadeOut()

$("#payment_method1").click(function(){
    $("#payment_method1").addClass('fa fa-check')
    $("#payment_method2").removeClass('fa fa-check')

    // alert($("#payment_method1").text())
    $("#Submit_order").val('Online Payment').fadeIn().addClass('pulse');

})


$("#payment_method2").click(function(){
    $("#payment_method2").addClass('fa fa-check')
    $("#payment_method1").removeClass('fa fa-check')

    // alert($("#payment_method2").text())
    $("#Submit_order").val('Pay On Delivery').fadeIn().addClass('pulse');


})
  

$('#paymentForm').on('submit', function (e) {
    e.preventDefault();
    payment_method= $('#Submit_order').val(),
    $.ajax({
        url: `/checkout_payment/${order_number}/`,
        type: 'POST',
        data: {

            payment_method: payment_method,
            csrfmiddlewaretoken: $('input[name=csrfmiddlewaretoken]').val(),

        },

        beforeSend: function(){
            // toastSuccess('order(s) Processed successfully Redirecting')
            toastSuccess('order(s) Processed successfully Redirecting')
            $("#please_wait").text('Please Wait processing ...').addClass('pulse')

        },
        success: function (res) {

            if (payment_method==='Pay On Delivery') {
                // $(location).attr('href','/checkout_success/')
                var url = '/checkout_success/'
                $(location).attr('href', url)
            }

            else if (payment_method==='Online Payment')
            // console.log(res)
          
            $(location).attr('href',res.payment_url)
            // window.location=res.payment_url
            
        },
        error: function () {
           console.log('error')
           toastError('was not abale to process payment yet order processed successfully')
           window.location='/checkout_fail/'

        }
    })

})


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








function moveUp(){
    $('body, html').animate({scrollTop:$('form').offset().top}, 'slow');

}

function moveDown(){
    
    $('body, html').animate({scrollTop:$('form').offset().left}, 'slow');
}

