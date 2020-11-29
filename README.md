Modelagem
Um circuito que controla um alarme residencial tem as seguintes características:

Possui uma chave com a qual o morador liga e desliga o alarme.
Possui um grupo de sensores espalhados pela residência, que detectam a presença de pessoas.
Possui uma sirene que toca em determinadas condições.
O controle do alarme tem o seguinte funcionamento:

Inicialmente: o alarme está desligado.
Se o alarme está desligado:
Independente dos sensores: a sirene não deve tocar.
Se o morador ligar a chave do alarme, arma o alarme para ligar dali a ∼30 segundos:
Neste intervalo:
Independente dos sensores: a sirene não deve tocar.
Se a chave é desligada, o alarme é desligado.
Se o alarme está ligado:
Se a chave é desligada, o alarme é desligado.
Se algum sensor detecta algo, aciona a sirene para tocar dali a ∼30 segundos.
Neste intervalo:
Mesmo que todos os sensores não detectem nada, continua com a sirene acionada.
Se a chave é desligada, o alarme é desligado.
Se a sirene está tocando:
Mesmo que todos os sensores não detectem nada: continua com a sirene tocando.
Se a chave é desligada: o alarme é desligado.
Entidade alarm
Implemente em VHDL o circuito de controle de alarme descrito anteriormente, levando em consideração a seguinte interface:
Interface:
Entidade: alarme
Generic n: natural
Número de sensores
Sinais de entrada:
sensores: bit vector(0 to n - 1)
n sensores
Se sensor i detecta presença de pessoa, sensores(i) = ’1’. Senão, sensores(i) = ’0’.
chave: bit
Quando o morador da casa liga a chave do alarme, chave passa para ’1’.
Quando o morador da casa desliga a chave do alarme, chave passa para ’0’.
clock: bit
Sinal de saída:
sirene: bit
Se sirene deve tocar, sirene = ’1’. Senão, sirene = ’0’.
 Observação:
Implemente o circuito de controle do alarme como uma máquina de estados:
É uma máquina de Moore ou de Mealy ?
A transição de estados deve ser síncrona.
Não há sinal de entrada de reset.
A saída deve ser assíncrona.
O sinal de clock terá um ciclo de 1 segundo.