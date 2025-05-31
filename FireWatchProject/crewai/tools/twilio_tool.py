from crewai_tools import tool
import requests
from requests.auth import HTTPBasicAuth
import os

@tool
def enviar_mensagem_twilio(numero: str, mensagem: str) -> str:
    """
    Envia uma mensagem WhatsApp usando a Twilio API.

    Parâmetros:
    - numero: Número do destinatário no formato E.164 (ex: whatsapp:+5511999999999)
    - mensagem: Texto da mensagem

    Retorna:
    - String de confirmação ou erro
    """
    try:
        # Configurações da Twilio via variáveis de ambiente
        account_sid = os.getenv("TWILIO_ACCOUNT_SID")
        auth_token = os.getenv("TWILIO_AUTH_TOKEN")
        from_number = os.getenv("TWILIO_FROM_NUMBER")  # ex: whatsapp:+14155238886

        if not all([account_sid, auth_token, from_number]):
            return "Erro: Credenciais da Twilio não configuradas corretamente."

        url = f"https://api.twilio.com/2010-04-01/Accounts/{account_sid}/Messages.json"

        payload = {
            "To": numero,
            "From": from_number,
            "Body": mensagem
        }

        response = requests.post(
            url,
            data=payload,
            auth=HTTPBasicAuth(account_sid, auth_token)
        )

        if response.status_code == 201:
            return f"✅ Mensagem enviada para {numero}"
        else:
            return f"❌ Erro ao enviar: {response.status_code} - {response.text}"

    except Exception as e:
        return f"⚠️ Exceção: {str(e)}"
