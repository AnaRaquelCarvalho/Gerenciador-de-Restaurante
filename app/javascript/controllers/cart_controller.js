checkout() 
{
  // 1. Capturamos o botão diretamente pelo seletor do Stimulus ou pelo alvo
  const button = this.element.querySelector('button[data-action*="checkout"]');
  const originalText = button.innerText;
  
  button.innerText = "Processando...";
  button.disabled = true;

  // 2. Limpeza profunda dos dados para evitar o erro de UTF-8
  var rawCart = JSON.parse(localStorage.getItem("cart") || "[]");
  var cleanCart = rawCart.map(function(item) {
    return {
      id: item.id,
      // Remove acentos e caracteres especiais que travam o Windows/Rails
      name: String(item.name).normalize("NFD").replace(/[\u0300-\u036f]/g, ""),
      quantity: parseInt(item.quantity) || 1,
      size: String(item.size || "M"),
      // Garante que o preço seja um número decimal puro
      price: parseFloat(String(item.price).replace("R$", "").replace(",", ".").trim()) || 0
    };
  });

  // 3. Chamada AJAX clássica
  fetch("/checkouts", {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json",
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content")
    },
    body: JSON.stringify({ cart: cleanCart })
  })
  .then(function(response) {
    if (!response.ok) {
      return response.json().then(function(err) { throw new Error(err.error || "Erro no servidor") });
    }
    return response.json();
  })
  .then(function(data) {
    if (data.url) {
      window.location.href = data.url;
    }
  })
  .catch(function(error) {
    console.error("Erro no Checkout:", error);
    alert("Houve um problema: " + error.message);
    button.innerText = originalText;
    button.disabled = false;
  });
}