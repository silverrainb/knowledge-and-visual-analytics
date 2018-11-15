function mult(n){
    nArray = [];
    var output = '<table border="1">';

    for (i = 1; i <= 20; i++) {nArray.push(n * i)}

    for (i = 0; i < 20; i++){
        if (i % 4 == 0) {
            output = output +'<tr>'
        }
        output = output + '<td>' + nArray[i] + '</td>';
        if (i % 4 == 3){
            output = output + '</tr>'
        }
    }
    output = output + '</table>';
    return output
}


function display_table(){
    var t = document.getElementById("part1_2");
    t.innerHTML = mult(document.getElementById('n').value);
}