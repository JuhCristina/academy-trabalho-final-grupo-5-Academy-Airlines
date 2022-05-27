Feature: Historico de lista de compras
    Como um usuário com conta no sistema
    Desejo consultar minhas últimas listas de compra
    Para visualizar minhas últimas compras

    Scenario: visualizar historico com sucesso
        * call read("hook.feature@criarLista")
        * def payload = read("payloadUsuario.json")

        Given url baseUrl
        Given path "list/history"
        And header X-JWT-Token = payload.token
        When method get
        Then status 200
        And match response == [{ id: "#string", userId: "#(payload.id)", description: "Supermarket", active: true, createdAt: "#string", updatedAt: "#string"}]

    Scenario: Não deve ser possivel visualizar o historico sem login
        * call read("hook.feature@criarLista")

        Given url baseUrl
        Given path "list/history"
        And header X-JWT-Token = ""
        When method get
        Then status 401

    Scenario: Não deve ser possivel visualizar o historico de outro usuario
        * call read("hook.feature@criarLista")
        * call read("hook.feature@login")
        * def payload = read("payloadUsuario.json")

        Given url baseUrl
        Given path "list/history"
        And header X-JWT-Token = payload.token
        When method get
        Then status 200
        And match response == []

    
    Scenario: apenas as últimas 10 listas mais recentes devem ser listadas no historico
        * def payload = read("payloadUsuario.json")
        * call read("hook.feature@criarLista")

        * def nomeLista = "lista1"
        * def nomeDoProduto = "Avocado"
        * def quantidade = 1
        * call read("hook.feature@desativaECriaNovaLista")

        * def nomeLista = "lista2"
        * call read("hook.feature@desativaECriaNovaLista")
        
        * def nomeLista = "lista3"
        * call read("hook.feature@desativaECriaNovaLista")

        * def nomeLista = "lista4"
        * call read("hook.feature@desativaECriaNovaLista")

        * def nomeLista = "lista5"
        * call read("hook.feature@desativaECriaNovaLista")

        * def nomeLista = "lista6"
        * call read("hook.feature@desativaECriaNovaLista")

        * def nomeLista = "lista7"
        * call read("hook.feature@desativaECriaNovaLista")

        * def nomeLista = "lista8"
        * call read("hook.feature@desativaECriaNovaLista")

        * def nomeLista = "lista9"
        * call read("hook.feature@desativaECriaNovaLista")

        * def nomeLista = "lista10"
        * call read("hook.feature@desativaECriaNovaLista")

        * def nomeLista = "lista11"
        * call read("hook.feature@desativaECriaNovaLista")

        Given url baseUrl
        Given path "list/history"
        And header X-JWT-Token = payload.token
        When method get
        Then status 200

    Scenario: Deve ser possivel consultar uma lista ativa através do historico
        * def payload = read("payloadUsuario.json")
        * call read("hook.feature@criarLista")

        Given url baseUrl
        Given path "list/history"
        And header X-JWT-Token = payload.token
        When method get
        * def idLista = response[0].id

        Given url baseUrl
        Given path "list/history", idLista
        And header X-JWT-Token = payload.token
        When method get

    Scenario: Deve ser possivel consultar uma lista inativa através do historico
        * def payload = read("payloadUsuario.json")
        * call read("hook.feature@criarLista")
        * def nomeLista = "lista1"
        * def nomeDoProduto = "Avocado"
        * def quantidade = 1
        * call read("hook.feature@desativaECriaNovaLista")

        Given url baseUrl
        Given path "list/history"
        And header X-JWT-Token = payload.token
        When method get
        * def idLista = response[1].id

        Given url baseUrl
        Given path "list/history", idLista
        And header X-JWT-Token = payload.token
        When method get




