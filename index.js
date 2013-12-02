var CSV_POSTCODE_LENGTH = 4,
	DELAY_BEFORE_UPDATING_TABLE = 1;

var typingTimer = undefined,
	loadedPostcodeFile = undefined,
	loadedData = [ ];

var updateResultsTable = function (postcode) {

	var columns = [ "Postcode.No.Spaces", "Postcode.Data.Status", "Lines.Less.Than.2Mbps.T.F", "Average.Speed.Mbps", "Median.Speed.Mbps", "Maximum.Speed.Mbps", "Superfast.Broadband.Available.T.F", "Number.of.Connections"],
		dataToDisplay = [ ];

	if ((postcode || "").length >= CSV_POSTCODE_LENGTH) {
		// the postcode is specified and long enough, I show the data
		dataToDisplay = _.filter(loadedData, function (row) { return row["Postcode.No.Spaces"].substring(0, postcode.length) == postcode; });
	}

	d3.select("#resultsContainer").html("");
	var	table = d3.select("#resultsContainer").append("table"),
        thead = table.append("thead"),
        tbody = table.append("tbody");

    // append the header row
    thead.append("tr")
        .selectAll("th")
        .data(columns)
        .enter()
        .append("th")
        .text(function(column) { return column; });

    // create a row for each object in the data
    var rows = tbody.selectAll("tr")
        .data(dataToDisplay)
        .enter()
        .append("tr");

    // create a cell in each row for each column
    var cells = rows.selectAll("td")
        .data(function(row) {
            return columns.map(function(column) {
                return {column: column, value: row[column]};
            });
        })
        .enter()
        .append("td")
            .text(function(d) { return d.value; });

};

var readPostcodeFile = function (beginsWith, callback) {
	d3.csv("data/" + beginsWith + ".csv", function (data) {
		loadedPostcode = beginsWith;
		loadedData = data;
		if (callback) callback(null);
	});
};

var displayPostcode = function (postcode) {
	if(postcode.length >= CSV_POSTCODE_LENGTH) {
		var startsWith = postcode.substring(0, CSV_POSTCODE_LENGTH);
		// long enough, I can display something
		if (loadedPostcodeFile != startsWith) {
			// I need to load a different file
			readPostcodeFile(startsWith, function (err) {
				updateResultsTable(postcode);
			});			
		} else {
			// I can stick to the file I already have
			updateResultsTable(postcode);
		}
	} else {
		// too short, I empty the table
		loadedPostcodeFile = undefined,
		loadedData = [ ];
		updateResultsTable();
	}
}

var checkPostcode = function () {
	clearTimeout(typingTimer);
	var postcode = d3.select("#postcode").property("value").toUpperCase();
	typingTimer = setTimeout(function () {
		displayPostcode(postcode);
	}, DELAY_BEFORE_UPDATING_TABLE * 1000);
}