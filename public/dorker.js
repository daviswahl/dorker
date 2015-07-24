Dorker = {
  attach: function() {
    var req = new XMLHttpRequest;
    req.onreadystatechange=function()
    {
      if (req.readyState==4 && req.status==200)
      {
        var cont = document.getElementsByClassName("attach-container")[0];
        var resp = JSON.parse(req.responseText);
        resp["resp"].forEach(function(e) {
          var d = document.createElement("div");
          d.innerHTML = e;
          var n = cont.firstChild;
          cont.appendChild(d);
        });
      }
    }
    req.open("GET", "read");
    req.send();
  },
  read: function() {
    setInterval(this.attach, 1000);
  },
  Containers:  { 
    toggleDisplayAll: function(e) {
       document.location = "?display_all=" + e.checked; 
    }
  }
}
