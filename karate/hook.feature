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
