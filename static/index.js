
document.querySelector(".homelogin").addEventListener("click",function (){ 
    

    document.querySelector(".home").style.display="none";
    document.querySelector(".login").style.display="block";
    document.querySelector(".goback").style.display="block";

});


document.querySelector(".homesign").addEventListener("click",function (){     

    document.querySelector(".home").style.display="none";
    document.querySelector(".signup").style.display="block";
    document.querySelector(".goback").style.display="block";

});

document.querySelector(".goback").addEventListener("click",function(){
    document.querySelector(".home").style.display="block";
    document.querySelector(".signup").style.display="none";
    document.querySelector(".goback").style.display="none";
    document.querySelector(".login").style.display="none";
    document.querySelector("#customersign").style.display="none";
    document.querySelector("#customerlogin").style.display="none";
    document.querySelector("#driversign").style.display="none";
    document.querySelector("#driverlogin").style.display="none";
});

document.querySelector(".signupcustomer").addEventListener("click",function(){
    
    document.querySelector("#customersign").style.display="block";
});

document.querySelector(".logincustomer").addEventListener("click",function(){
    
    document.querySelector("#customerlogin").style.display="block";
});

document.querySelector(".signupdriver").addEventListener("click",function(){
    
    document.querySelector("#driversign").style.display="block";
});

document.querySelector(".logindriver").addEventListener("click",function(){
    
    document.querySelector("#driverlogin").style.display="block";
});