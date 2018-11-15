var _rows = []
var _tableHeight = 0
var _names;

function loadData() {
    d3.csv("presidents.csv",
        function (error, csv) {
            csv.forEach(function (row) {
                _rows.push(row);
            })

            var table = d3.select("#datatable").append("table");
            table.classed("table table-striped", true);
            thead = table.append("thead");
            tbody = table.append("tbody");

            thead.append("th").text("Name");
            thead.append("th").text("Height");
            thead.append("th").text("Weight");

            var tr = tbody.selectAll("tr")
                .data(_rows)
                .enter().append("tr");

            var td = tr.selectAll("td")
                .data(function (d) { return [d.Name, d.Height, d.Weight]; })
                .enter().append("td")
                .text(function (d) { return d; });
        });

    d3.select("#presidentSearch").on("keyup", searchPresidents);
}

function searchPresidents() {
    var inputField = d3.select("#presidentSearch");
    var srchText = inputField.property("value");
    var tableRows = d3.select("#datatable").select("tbody").selectAll("tr");

    // Filter the table rows based on president's name
    tableRows[0].forEach(function (row) {
        var td = row.cells[0]
        if (td.innerText.search(srchText) > -1) {
            // Found
            d3.select(row).classed("hidden", false)
        }
        else {
            d3.select(row).classed("hidden", true)
        }
    });
}