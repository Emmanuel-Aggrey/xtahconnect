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
   
        

  
    if ($.trim($("#id_name").val()) === "" || $.trim($("#id_address").val()) === "" || $.trim($("#id_phone_number").val()) === "" || $.trim($("#id_region").val()) === "" || $.trim($("#id_city").val()) === "" || $.trim($("#id_email").val()) === "" ) {
        // alert('all fields are required');
        toastError('all fields are required')
        moveUp()

        return false;
        
    }
    else if(document.getElementById('payment1').checked===false && document.getElementById('payment2').checked===false && document.getElementById('payment3').checked===false ) {
        moveUp()
        // alert('please select a payment method');
        
        toastError('please select a payment method')

        return false;
    }

    else if(document.getElementById('payment3').checked===true && document.getElementById('id_order').value==='' && $("#save_checkout").click()) {
       
        // alert('please select a payment method');
        
        $("#other").css( "border-color", "red" );
        
        toastError('please specify your payment option')
        moveUp()
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
                    payment_method:$('input[name="payment_method"]:checked').val(),
                    order: $('#id_order').val(),
                    
                    csrfmiddlewaretoken: $('input[name=csrfmiddlewaretoken]').val(),

                },
                beforeSend: function () {
                    console.log('sending data')
                    // getLocation()
                    // $("#save_checkout").text("Submiting Your Orders").addClass('icon-spinner')
                    toastSuccess('Submiting Your Order(s)')
                    // alert($('input[name="payment_method"]:checked').val(),)
                    // make_payments()
                   
                },

                success: function () {
                    // $("#save_checkout").text("Submiting Your Orders").addClass('icon-check')

                  
                    console.log('saved')
                    // var url = '/checkout_success/'
                    // $(location).attr('href', url)
                    payment_method = $('input[name="payment_method"]:checked').val()

                    if(payment_method==='On Delivery' || payment_method==='Other method'){
                        var url = '/checkout_success/'
                    $(location).attr('href', url)
                    }
                    

                    else if(payment_method==='Online'){
                        make_payments()
                        // window.location=''
                    }
                    // window.location.href = '/url-path'+data.url; 
                 
                   
                  
                },
                error: function () {
                    // alert('error no saved try again')
                    toastError('error not saved try again')

                }

            })
        }
  
});


$(".radio").click(function() {
  
if(document.getElementById('payment1').checked===true || document.getElementById('payment2').checked===true){

    moveDown()
    // alert($('input[name="payment_method"]:checked').val())
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





function make_payments() {

   
    $.ajax({
        url: '/make_payment_url/',
        type: 'GET',

        beforeSend: function(){
            toastSuccess('order(s) Processed successfully Redirecting')

        },
        success: function (res) {

          
            $(location).attr('href',res.payment_url)
            // window.location=res.payment_url
            

        
        },
        error: function () {
           console.log('error')
           toastError('was not abale to process payment yet order processed successfully')

        }
    })
}




function moveUp(){
    $('body, html').animate({scrollTop:$('form').offset().top}, 'slow');

}

function moveDown(){
    
    $('body, html').animate({scrollTop:$('form').offset().left}, 'slow');
}

