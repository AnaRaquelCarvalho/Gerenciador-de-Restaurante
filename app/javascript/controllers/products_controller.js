import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { size: String, product: Object }

  addToCart() {
    console.log("Product: ", this.productValue)
    const cart = localStorage.getItem("cart")
    let cartArray = []

    if (cart) {
      cartArray = JSON.parse(cart)
      const foundIndex = cartArray.findIndex(
        item => item.id === this.productValue.id && item.size === this.sizeValue
      )

      if (foundIndex >= 0) {
        cartArray[foundIndex].quantity = parseInt(cartArray[foundIndex].quantity) + 1
      } else {
        cartArray.push({
          id: this.productValue.id,
          name: this.productValue.name,
          price: this.productValue.price,
          size: this.sizeValue,
          quantity: 1
        })
      }
    } else {
      cartArray.push({
        id: this.productValue.id,
        name: this.productValue.name,
        price: this.productValue.price,
        size: this.sizeValue,
        quantity: 1
      })
    }

    localStorage.setItem("cart", JSON.stringify(cartArray))

    // --- A CORREÇÃO ESTÁ AQUI ---
    // Esta linha faz o navegador ir para a página do carrinho automaticamente
    window.location.href = "/cart" 
  }

  selectSize(e) {
    this.sizeValue = e.target.value
    const selectedSizeEl = document.getElementById("selected-size")
    selectedSizeEl.innerText = `Selected Size: ${this.sizeValue}`
  }

  connect() {
    console.log("caiu aqui");
  }
}