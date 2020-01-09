Skip to content
Search or jump to…

Pull requests
Issues
Marketplace
Explore

@unfinishedideas
unfinishedideas
/
codereview4
1
00
 Code Issues 0 Pull requests 0 Actions Projects 0 Wiki Security Insights Settings
codereview4/js/scripts.js
@unfinishedideas unfinishedideas determined that not using a orderForm object was causing a lot of unn…
cf3776e on Nov 8, 2019
166 lines (145 sloc)  4.58 KB

// Init Variables --------------------------
var pizzaId = 1;
var pizzaArray = [];

// function OrderForm() {
//   this.pizzasList = []
//   this.id = 1;
// }

function Pizza(toppings, size, pizzaId) {
  this.toppings = toppings;
  this.size = size;
  this.pizzaId = pizzaId;
  this.price = 10;
}

Pizza.prototype.getPrice = function(){
  //Add Costs for each topping
  for(var i = 0; i < this.toppings.length; i++){
    // if (this.toppings[i] === "pep" || this.toppings[i] === "gep"){
    //   console.log("pep pep");
    //   this.price += 1;
    // }
    this.price += 1;
  };
  //Do math based on the size of the Pie
  if (this.size === "Small") {
    this.price /= 2;
  }
  else if (this.size === "Large") {
    this.price *= 2;
  }
};

function makePizza (toppings, size) {
  var newPizza = new Pizza(toppings, size, pizzaId);
  newPizza.getPrice();
  pizzaArray.push(newPizza);
  pizzaId +=1;
  return newPizza;
}

function populateCurrentPizzaList (){
  var currentPizzaHtml = "";
  var j = 1;
  for (var i = 0; i < pizzaArray.length; i++) {
    currentPizzaHtml += '<li id="' + pizzaArray[i].pizzaId + '">Pizza Number: ' + j + "</li>";
    j++
  };
  return currentPizzaHtml
}
function deletePizza(id){

  if (pizzaArray.length > 1) {
    pizzaArray.splice(id-1, 1)
  } else if (pizzaArray.length === 1){
    pizzaArray = [];
    pizzaId = 1;
  }
  displayOrder();
}

function changeSelectedPizza(id) {
  var pizza = pizzaArray[id-1];
  var outputString = "";
    outputString += pizza.size + " Pizza:";
  if (pizza.toppings.length < 1){
    outputString += "Just a plain 'ol cheese pizza'"
  } else {
    outputString += pizza.toppings;
  }
  return outputString += "" + "Price: ";
};

// Front End ---------------------------------------------------------
$(document).ready(function(){
  // Title effects?
  // $("#bannerText").fadeIn();
  // var newOrderForm = new OrderForm();
  var numberOfPizzas = 0;
  $(".numberOfPizzas").text("0");

  // Get user input -------------------------
  $(".pizzaToppingForm").submit(function(event){
    event.preventDefault();
    var toppingsArray = [];

    $("input:checkbox[name=topping]:checked").each(function(){
      var topping = $(this).val();
      toppingsArray.push(topping);
    });
    var pizzaSize = $("input:radio[name=size]:checked").val();

    makePizza(toppingsArray, pizzaSize);
    $(".numberOfPizzas").text(pizzaArray.length);
    $("ul.currentPizzaList").html(populateCurrentPizzaList());
    // $("#currentPizza").text(changeSelectedPizza(pizzaId));
  });

  // Display the Order --------------------
  $("#orderDisplayBtn").click(function(){
    if (pizzaArray.length >= 1){
      displayOrder();
    }
  });

  // Go back to Order form -----------------
  $("#addMore").click(function(){
    $("ul.currentPizzaList").html(populateCurrentPizzaList());
    $("#currentPizza").text("");
    $(".orderDisplay").hide();
    $(".currentPizzaList").show();
    $("#orderDisplayBtn").show();
    $(".pizzaToppingForm").show();
  });

  // Change currently displayed Pizza -----
  $(".currentPizzaList").on("click", "li", function() {
    $("#currentPizza").text("")
    $("#currentPizza").text(changeSelectedPizza(this.id));
  });
  // Delete a Pizza ------------------------
  $(".pizzaList").on("click", "button", function() {
    deletePizza(this.id)
  });

  // Clear order button reloads the page ---
  $("#clearOrderBtn").click(function(){
    window.location.reload();
  });

  // Display the order on the screen
  function displayOrder(){
    $("#orderDisplayBtn").hide();
    $(".currentPizzaList").hide();
    var pizzaHtml = "";
    var totalPrice = 0;

    // Check to see if there are pizzas and set display for clearBtn (necessary for delete function calling displayOrder)
    if (pizzaArray.length < 1){
      $("#clearOrderBtn").hide();
    } else if (pizzaArray.length >= 1){
      $("#clearOrderBtn").show();
    }

    // Populate the pizza list on screen
    var i = 1;
    pizzaArray.forEach(function(pizza) {
      pizzaHtml += '<li id="' + pizza.pizzaId + '">Pizza Number: ' + i + "<br> Toppings: " + pizza.toppings + "<br>Size: " + pizza.size + "<br>Price: $" + pizza.price + '<br><button type="button" id="' + pizza.pizzaId + '" class="deletePizzaBtn">Remove?</button>' + "</li>";
      i ++;
    });
    $(".pizzaList").html(pizzaHtml);

    // Calculate Total Price
    pizzaArray.forEach(function(pizza){
      totalPrice += pizza.price;
    });

    // Display the Pizzas and total price to the user
    $(".pizzaToppingForm").hide();
    $(".numberOfPizzas").text(pizzaArray.length);
    $(".priceDump").text(totalPrice);
    $(".orderDisplay").show();
  }

}); // Close document-ready.
