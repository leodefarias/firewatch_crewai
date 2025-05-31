from crew import montar_crew

if __name__ == '__main__':
    resultado = montar_crew().kickoff(inputs={
        "contexto": (
            "Este projeto se chama FireWatch. "
            "Seu objetivo é detectar queimadas, registrar ocorrências com localização e severidade, "
            "notificar usuários via WhatsApp usando a API da Twilio, "
            "e apresentar os dados em um frontend interativo com React e Leaflet. "
            "Além disso, o projeto inclui um simulador em Python que prioriza o atendimento às ocorrências "
            "mais severas usando algoritmos e estruturas como fila e heap."
        )
    })

    print("\n=== RESULTADO FINAL DA CREW ===\n")
    print(resultado)
