import Rails from "@rails/ujs"
const startBtn = document.getElementById("start");
const resetBtn = document.getElementById("reset");
const saveLapBtn = document.getElementById("save-lap-btn");
const saveStopwatchBtn = document.getElementById("save-stopwatch-btn");
const hoursLabel = document.getElementById("hours");
const minutesLabel = document.getElementById("minutes");
const secondsLabel = document.getElementById("seconds");
const labelInput = document.querySelector('input[name="label"]');
const panelLaps = document.getElementById("show-laps");
const userId = saveLapBtn.dataset.userId;
let totalTimeSeconds = 0;
let interval;
let difference = 0;
let savedTime = 0;
let previousTime = 0;
let paused = false;
let running = false;
let stopwatchId = '';
let laps = [];

function startTimer() {
  interval = setInterval(showTime, 1000);
  running = true;
  paused = false;
}

function stopTimer() {
  clearInterval(interval);
  savedTime = totalTimeSeconds;
  paused = true;
  running = false;
  startBtn.innerText = 'Start';
}

startBtn.addEventListener('click', () => {
  if (!running) {
    startTimer();
    startBtn.innerText = 'Pause';
  } else {
    stopTimer(); 
  }
});


resetBtn.addEventListener('click', () => {
  clearInterval(interval);
  totalTimeSeconds = 0;
  difference = 0;
  previousTime = 0;
  savedTime = 0;
  hoursLabel.innerText = "00";
  minutesLabel.innerText = "00";
  secondsLabel.innerText = "00";
  laps = [];
  paused = false;
  running = false;
  labelInput.value = "";
  panelLaps.innerHTML = '';
});


saveLapBtn.addEventListener('click', () => {
  if (running) {
    difference = totalTimeSeconds - previousTime;
    previousTime = totalTimeSeconds;
    laps.push({time: previousTime, difference: difference});
    let lapContainer = document.createElement("span");
    lapContainer.innerText = `Duration: ${previousTime} - Difference: ${difference}`;
    panelLaps.appendChild(lapContainer);
  } else {
    alert("Stopwatch is not running"); 
  }
});

saveStopwatchBtn.addEventListener('click', () => {
  if(!labelInput.value) {
    alert("Label is empty");
  } else if(previousTime === 0) {
    alert("There is no records");
  }else {
    saveRecordOfStopwatch();
  }
});

function saveRecordOfStopwatch() {
  fetch(`/users/${userId}/stopwatches`, {
    method: 'POST',
    body: JSON.stringify({label: labelInput.value, laps: laps}),
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': Rails.csrfToken()
    },
    credentials: 'same-origin'
  }).then(response => window.location.href = response.url);
}

function showTime() {
  totalTimeSeconds += 1;
  let hours = Math.floor(totalTimeSeconds / 3600);
  let minutes = Math.floor(totalTimeSeconds / 60);
  let seconds = Math.floor(totalTimeSeconds % 60);
  hoursLabel.innerText = hours.toLocaleString('en-US', {minimumIntegerDigits: 2, useGrouping:false});
  minutesLabel.innerText = minutes.toLocaleString('en-US', {minimumIntegerDigits: 2, useGrouping:false});
  secondsLabel.innerText = seconds.toLocaleString('en-US', {minimumIntegerDigits: 2, useGrouping:false});
}
