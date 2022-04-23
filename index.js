
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
});