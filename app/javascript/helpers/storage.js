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

function findObject(rouletteId) {
  return JSON.parse(sessionStorage.getItem(rouletteId))
}

function getRouletteId() {
  return location.pathname.split('/')[2]
}
