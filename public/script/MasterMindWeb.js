var codeAttempt = []

function colorSelect(color) {
  switch(color) {
    case 'red':
      codeAttempt.push('red');
      break;
    case 'green':
      codeAttempt.push('green');
      break;
    case 'yellow':
      codeAttempt.push('yellow');
      break;
    case 'blue':
      codeAttempt.push('blue');
      break;
  }
}

var Red = document.getElementById("red")
Red.addEventListener('click', colorSelect('red'));

var Green = document.querySelector('#green');
green.addEventListener('click', colorSelect('green'));

var Yellow = document.querySelector('#yellow');
Yellow.addEventListener('click', colorSelect('yellow'));

var Blue = document.querySelector('#blue');
Blue.addEventListener('click', colorSelect('blue'));

