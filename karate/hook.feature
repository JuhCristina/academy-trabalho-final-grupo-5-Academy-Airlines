Feature: hook

    @criarUsuario
    Scenario: Criar Usuario
        * def name = java.util.UUID.randomUUID() + "user"
        * def email = java.util.UUID.randomUUID() + "@academy-airlines.com"
        * def password = Date.now() + "academy"
        * def payload = read("payloadUsuario.json")


        Given url baseUrl
        And path "/users"
        And request { name: "#(payload.name)", email: "#(payload.email)", password: "#(payload.password)"}
        When method post
        
        * def id = response.id
        * def isAdmin = response.is_admin

    @login
    Scenario: login
        * call read("hook.feature@criarUsuario")
        * def payload = read("payloadUsuario.json")

        Given url baseUrl
        Given path "auth/login"
        And form field email = payload.email
        And form field password = payload.password
        When method post
        Then status 200
        * def token = response.session.token

    @criarLista
    Scenario: criar lista de compras
        * call read("hook.feature@login")
        * def payload = read("payloadUsuario.json")

        Given url baseUrl
        Given path "list"
        And header X-JWT-Token = payload.token
        And request { description: "Supermarket", items: [{ name: "Avocado", amount: 1}]}
        When method post
        Then status 201

    @desativaLista 
        Scenario: desativaLista
        * def payload = read("payloadUsuario.json")

        Given url baseUrl
        Given path "list"
        And header X-JWT-Token = payload.token
        When method patch
        Then status 204

    
    @desativaECriaNovaLista
     Scenario: 
        * call read("hook.feature@desativaLista")
        * def payload = read("payloadUsuario.json")
        * def payloadLista = read("payloadLista.json")

        Given url baseUrl
        Given path "list"
        And header X-JWT-Token = payload.token
        And request { description: "#(nomeLista)", items: [{ name: "#(nomeDoProduto)", amount: "#(quantidade)"}]}
        When method post
        Then status 201
