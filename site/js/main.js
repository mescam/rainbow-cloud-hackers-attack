var apiURL = "https://4spqeele2e.execute-api.eu-west-1.amazonaws.com/prod"

var $search = $("#search");
var $searchInput = $search.find("input").first();
var $searchButton = $search.find("button").first();
var $table = $("#tableres");
var $tableres = $("#result").find("tbody").first();

function tr(id, hash) {
	$tableres.append('<tr id="' + id + '" class="active"></tr>')
	$('#' + id).append("<td class='hash'>" + hash + "</td><td class='status'>pending</td><td class='result'></td>");
}

function update_tr(id, status, result) {
	var $obj = $('#' + id);
	$obj.find('.status').text(status);
	$obj.find('.result').text(result);
	if (status === "executing")
		$obj.attr("class", "info");
	else if (status === "done") {
		if (result == null)
			$obj.attr("class", "danger");
		else
			$obj.attr("class", "success");
	}
}

function poll(id) {
	$.get(apiURL + "/find/" + id)
		.done(function(resp) {
	    	console.log(resp);
	    	update_tr(id, resp.status, resp.result);
	    	if(resp.status === 'done') {
	    		console.log(resp);
	    	}
	    	else {
	    		setTimeout(poll, 3000, id);
	    	}
	  	})
	  	.fail(function() {
	    	// alert( "error" );
	  	});
}

function search() {
	$table.show();
	var hash = $searchInput.val();
	$searchInput.val('');
	var data = JSON.stringify({"hash": hash})
	$.post(apiURL + "/find", data)
		.done(function(resp) {
	    	var id = resp.id;
	    	tr(id, hash);
	    	setTimeout(poll, 3000, id);
	  	})
	  	.fail(function() {
	    	alert( "error" );
	  	});
}

$searchButton.on("click", function() {
	search();
});

$searchInput.on("keypress", function (e) {
  if (e.which == 13) {
    search();
    return false;
  }
});

