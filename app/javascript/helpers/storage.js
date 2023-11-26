export function saveTargets(rouletteName, targets) {
  sessionStorage.setItem(rouletteName, targets.toString())
}

export function save(key, value) {
  sessionStorage.setItem(key, value.toString())
}

export function find(key) {
  return sessionStorage.getItem(key)
}

export function getTargets(rouletteName) {
  const targets = sessionStorage.getItem(rouletteName).split(',')
  if (targets[0] === '') {
    return [1, 2, 3, 4]
  }
  return targets
}