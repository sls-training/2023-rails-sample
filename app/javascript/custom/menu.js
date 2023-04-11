// toggle lisnterを追加してクリックのリッスン
document.addEventListener("turbo:load", () => {
  let hamburger = document.querySelector("#hamburger")
  hamburger.addEventListener("click", event => {
    event.preventDefault()
    let menu = document.querySelector("#navbar-menu")
    menu.classList.toggle("collapse")
  })
  
  
  let account = document.querySelector("#account")
  account.addEventListener("click", event => {
    // jsのいつものやーつ
    // formの動作を止める => submitしない確かevent.submit()すればできるっけ
    event.preventDefault();
    let menu = document.querySelector("#dropdown-menu")
    menu.classList.toggle("active")
  })
})