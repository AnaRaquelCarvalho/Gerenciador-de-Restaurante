import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.renderCart()
  }

  renderCart() {
    const cart = JSON.parse(localStorage.getItem("cart")) || []
    const itemsContainer = document.getElementById("cart-items")
    const totalContainer = document.getElementById("total")
    
    itemsContainer.innerHTML = ""
    totalContainer.innerHTML = ""

    if (cart.length === 0) {
      itemsContainer.innerHTML = "<p>O carrinho está vazio.</p>"
      return
    }

    let total = 0

    cart.forEach((item, index) => {
      total += item.price * item.quantity

      // Cria a div da linha
      const itemDiv = document.createElement("div")
      itemDiv.className = "flex items-center gap-2"

      // Texto igual ao print: Item: Nome - Preço - Tamanho - Quantidade: X
      const textSpan = document.createElement("span")
      textSpan.innerText = `Item: ${item.name} - ${item.price} - ${item.size.toUpperCase()} - Quantidade: ${item.quantity}`
      
      // Botão Remover cinza
      const removeBtn = document.createElement("button")
      removeBtn.innerText = "Remover"
      removeBtn.className = "bg-slate-500 text-white px-2 py-1 rounded text-xs ml-2 hover:bg-slate-600"
      removeBtn.onclick = () => this.removeItem(index)

      itemDiv.appendChild(textSpan)
      itemDiv.appendChild(removeBtn)
      itemsContainer.appendChild(itemDiv)
    })

    totalContainer.innerText = `Total: ${total}`
  }

  removeItem(index) {
    let cart = JSON.parse(localStorage.getItem("cart"))
    cart.splice(index, 1)
    localStorage.setItem("cart", JSON.stringify(cart))
    this.renderCart()
  }

  clear() {
    localStorage.removeItem("cart")
    this.renderCart()
  }
  removeFromCart(event){
    const cart = JSON.parse(localStorage.getItem("cart"))
    const id = event.target.value
    const index = cart.findIndex(item => item.id === id)
    cart.splice(index, 1)
    localStorage.setItem("cart", JSON.stringify(cart))
    window.location.reload()  
  }
}