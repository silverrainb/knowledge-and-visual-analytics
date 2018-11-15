function reverse_string(string){
    output = string.split('').reverse().join('');
    return output
}

function print_reverse(){
    var target = document.getElementById('part1_1');
    target.innerHTML = reverse_string(document.reverse.raw.value);
}