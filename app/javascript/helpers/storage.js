export function save(key, value) {
  const rouletteId = getRouletteId()
  const obj = findObject(rouletteId) || {}
  obj[key] = value
  const jsonObj = JSON.stringify(obj)
  sessionStorage.setItem(rouletteId, jsonObj)
}

export function findByKey(key) {
  const rouletteId = getRouletteId()
  const obj = findObject(rouletteId)
  return obj[key]
}

export function resetLotteryCandidates(key, targets) {
  const numbers = []
  for (let i = 0; i < targets.length; i++) {
    numbers.push(i)
  }

  save(key, numbers)
}

function findObject(rouletteId) {
  return JSON.parse(sessionStorage.getItem(rouletteId))
}

function getRouletteId() {
  return location.pathname.split('/')[2]
}
