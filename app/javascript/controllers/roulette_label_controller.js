import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    index: Number,
    count: Number,
    radius: Number,
    topPlus: Number,
    leftPlus: Number,
    mdRadius: Number,
    mdTopPlus: Number,
    mdLeftPlus: Number,
    lgRadius: Number,
    lgTopPlus: Number,
    lgLeftPlus: Number
  }

  connect() {
    this.setLabelPosition()
  }

  setLabelPosition() {
    const obj = this.switchByWidth()
    console.log(obj)
    const angle = 360 / this.countValue
    const itemPositionAngle = angle / 2 + angle * this.indexValue
    const position = this.calcTopAndLeftPosition(
      this.element,
      itemPositionAngle,
      obj.radius,
      obj.leftPlus,
      obj.topPlus
    )
    const rotateAngle = this.calcRotateAngle(itemPositionAngle)
    this.element.style = `left: ${position[0]}px; top: ${position[1]}px; transform: rotate(${rotateAngle}deg);`
  }

  private

  switchByWidth() {
    if (window.matchMedia('(min-width: 1096px)').matches) {
      return {
        radius: this.lgRadiusValue,
        topPlus: this.lgTopPlusValue,
        leftPlus: this.lgLeftPlusValue
      }
    }

    if (window.matchMedia('(min-width: 768px)').matches) {
      return {
        radius: this.mdRadiusValue,
        topPlus: this.mdTopPlusValue,
        leftPlus: this.mdLeftPlusValue
      }
    }

    return {
      radius: this.radiusValue,
      topPlus: this.topPlusValue,
      leftPlus: this.leftPlusValue
    }
  }

  calcTopAndLeftPosition(element, angle, radius, leftPlus, topPlus) {
    const radian = (this.calcRadian(angle) * Math.PI) / 180
    let leftPosition = Math.cos(radian) * radius
    let topPosition = Math.sin(radian) * radius

    if (angle >= 270) {
      leftPosition *= -1
      topPosition *= -1
    } else if (angle >= 180) {
      leftPosition *= -1
    } else if (angle < 90) {
      topPosition *= -1
    }

    const clientHeight = parseFloat(element.clientHeight)
    const lineHeight = parseFloat(
      getComputedStyle(element)
        .getPropertyValue('line-height')
        .match(/[0-9.]+/g)
    )
    const lineCount = clientHeight / lineHeight

    if (lineCount > 1) {
      topPosition -= topPlus * 2
    } else {
      topPosition -= topPlus
    }

    leftPosition -= leftPlus

    return [leftPosition, topPosition]
  }

  calcRotateAngle(angle) {
    if (angle - 90 > 270) {
      return angle - 540
    }

    return angle - 90
  }

  calcRadian(angle) {
    if (angle < 90) {
      return 90 - angle
    } else if (angle < 180) {
      return angle - 90
    } else if (angle < 270) {
      return 270 - angle
    } else {
      return angle - 270
    }
  }
}
