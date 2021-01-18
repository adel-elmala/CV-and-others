//   // people data -----------------------------------
//       var randomNamber= Math.floor(Math.random()*88)+1;
//       var data=angular.module("myApp",[]);
//       data.controller("myCtrl",function($scope,$http){
//         $http.get("https://swapi.co/api/people/"+randomNamber+'/').then(function(response){
//           $scope.people=response.data;
//           console.log($scope.people)
//
//         });
//         $http.get("https://swapi.co/api/starships/"+randomNamber+'/').then(function(response){
//           $scope.starship=response.data;
//           console.log($scope.starship)
//         });
//         $http.get("https://swapi.co/api/films/"+randomNamber+'/').then(function(response){
//           $scope.film=response.data;
//           console.log($scope.film)
//         });
//         $http.get("https://swapi.co/api/planets/"+randomNamber+'/').then(function(response){
//           $scope.planet=response.data;
//           console.log($scope.planet)
//         });
//
//     });
//
//
//
//
// // -----------------------------------------------
  // people data -----------------------------------
      var randomNamber= Math.floor(Math.random()*88)+1;
      var data=angular.module("myApp",[]);
      data.controller("myCtrl",function($scope,$http){
        $http.get("https://swapi.co/api/people/").then(function(response){
          $scope.people=response.data.results;
          console.log($scope.people);

        });
        // $http.get("https://swapi.co/api/starships/").then(function(response){
        //   $scope.starship=response.data.results;
        //   console.log($scope.starship)
        // });
        // $http.get("https://swapi.co/api/films/").then(function(response){
        //   $scope.film=response.data;
        //   console.log($scope.film)
        // });
        // $http.get("https://swapi.co/api/planets/").then(function(response){
        //   $scope.planet=response.data;
        //   console.log($scope.planet)
        // });

    });

// -----------------------------------------------


//
// starship data------------------------------------
 var starships=angular.module("myApp1",[]);
 starships.controller("myCtrl1",function($scope,$http){
   $http.get("https://swapi.co/api/starships/").then(function(response){
     $scope.starship=response.data.results;
     console.log($scope.starship);
   });
 });
 // ------------------------------------------------
// // films data------------------------------------
//  var films=angular.module("myApp2",[]);
//  films.controller("myCtrl2",function($scope,$http){
//    $http.get("https://swapi.co/api/films/"+randomNamber+'/').then(function(response){
//      $scope.film=response.data;
//    });
//  });
//  // ------------------------------------------------
// // planets data------------------------------------
//  var planets=angular.module("myApp3",[]);
//  planets.controller("myCtrl3",function($scope,$http){
//    $http.get("https://swapi.co/api/planets/"+randomNamber+'/').then(function(response){
//      $scope.planet=response.data;
//    });
//  });
//  // ------------------------------------------------














    //
    // var randomNamber= Math.floor(Math.random()*88)+1;
    // var app1=angular.module("App1",[]);
    // app.controller("Ctrl1",function($scope,$http){
    //
    //     $http.get("https://swapi.co/api/people/"+randomNamber+'/').then(function(response){
    //       $scope.people=response.data;
    //
    //     })
    //
    //   }
    // });
