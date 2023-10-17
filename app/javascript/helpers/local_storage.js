export function resetStorage(roulette_name) {
  sessionStorage.removeItem(roulette_name);
}

export function createLotteryTargets(roulette_name, targets) {
  sessionStorage.setItem(roulette_name, targets.toString())
}

export function getLotteryTargets(roulette_name) {
  const targets = sessionStorage.getItem(roulette_name).split(',')
  if (targets[0] === '') {
    return [1, 2, 3, 4]
  }
  return targets
}
