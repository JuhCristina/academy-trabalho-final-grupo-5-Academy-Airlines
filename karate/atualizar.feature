Feature: Atualizar perfil
    Como um usuário com conta no sistema
    Desejo atualizar minhas informações básicas
    Para manter meus dados atualizados no sistema.

    Scenario: altero os dados com sucesso
        * call read("hook.feature@login")
        * def name = java.util.UUID.randomUUID() + "user"
        * def email = java.util.UUID.randomUUID() + "@academy-airlines.com"
        * def payload = read("payloadUsuario.json")

        Given url baseUrl
        Given path "users"

        And header X-JWT-Token = payload.token
        And request { name: "#(name)", email: "#(email)" }
        When method put
        Then status 200
        And match response == { id: "#string", name: "#(payload.name)",email:"#(payload.email)", is_admin: false, createdAt: "#string", updatedAt: "#string" }

    Scenario: atualizo email para um já existente
        * call read("hook.feature@login")
        * def payload = read("payloadUsuario.json")

        Given url baseUrl
        Given path "users"
        And header X-JWT-Token = payload.token
        * call read("hook.feature@criarUsuario")
        * def payload = read("payloadUsuario.json")
        And request { name: "#(payload.name)", email: "#(payload.email)" }
        When method put
        Then status 422
        And match response == { "error":"E-mail already in use." }

    Scenario: atualizo nome com mais de 100 caracteres
        * call read("hook.feature@login")
        * def payload = read("payloadUsuario.json")
        * def name = java.util.UUID.randomUUID() + "07cf98a4-8070-4f74-bd40-43bb039e569b07cf98a4-8070-4f74-bd40-43bb0"

        Given url baseUrl
        Given path "users"
        And header X-JWT-Token = payload.token
        And request { name: "#(name)", email: "#(payload.email)" }
        When method put
        Then status 400
        And match response == { "error": "Bad request." }

    Scenario: atualizo email com mais de 60 caracteres
        * call read("hook.feature@login")
        * def payload = read("payloadUsuario.json")
        * def email = java.util.UUID.randomUUID() + "094e3591c48bd@academy.com"
        
        Given url baseUrl
        Given path "users"
        And header X-JWT-Token = payload.token
        And request { name: "#(payload.name)", email: "#(email)" }
        When method put
        Then status 400
        And match response == { "error": "Bad request." }