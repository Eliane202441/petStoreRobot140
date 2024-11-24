*** Settings ***
Library    RequestsLibrary

*** Variables ***
${url}         https://petstore.swagger.io/v2/store/order  

${id}          1212                       # ID do pedido
${petId}       151174809                  # ID do pet associado ao pedido
${quantity}    1                          # Quantidade do pedido
${shipDate}    2024-11-05T00:08:51.134Z   # Data de envio do pedido
${status}      placed                     # Status do pedido
${complete}    True                       # Pedido completo (booleano)

*** Test Cases ***
POST order
    
    ${body}    Create Dictionary    id=${id}    petId=${petId}    quantity=${quantity}
    ...        shipDate=${shipDate}    status=${status}    complete=${complete}
    ${response}    POST    url=${url}    json=${body}
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

     # Validar retorno
    Status Should Be    200
    Should Be Equal    ${response_body}[id]          ${{int($id)}}
    Should Be Equal    ${response_body}[status]      ${status}
    Should Be Equal    ${response_body}[quantity]   ${quantity}


GET order
    
    ${response}    GET     ${{$url + '/' + $id}}
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

   
    Status Should Be    200
    Should Be Equal     ${response_body}[id]         ${id}
    Should Be Equal     ${response_body}[status]     ${status}
    Should Be Equal     ${response_body}[complete]   ${complete}

DELETE order
    
    ${response}    DELETE     ${{$url + '/' + $id}}
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    # Validar retorno
    Status Should Be    ${response.status_code}    200
    Should Be Equal     ${response_body}[message]    ${id}
