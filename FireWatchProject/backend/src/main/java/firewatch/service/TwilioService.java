package firewatch.service;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;

@Service
public class TwilioService {

    @Value("${twilio.account.sid}")
    private String accountSid;

    @Value("${twilio.auth.token}")
    private String authToken;

    @Value("${twilio.whatsapp.from}")
    private String fromWhatsAppNumber;

    @PostConstruct
    public void initTwilio() {
        try {
            if (accountSid != null && !accountSid.equals("your_account_sid") && 
                authToken != null && !authToken.equals("your_auth_token")) {
                Twilio.init(accountSid, authToken);
                System.out.println("✅ Twilio inicializado com sucesso!");
            } else {
                System.out.println("⚠️  Twilio não configurado - usando credenciais de exemplo");
                System.out.println("   Para ativar WhatsApp, configure as variáveis:");
                System.out.println("   - TWILIO_ACCOUNT_SID");
                System.out.println("   - TWILIO_AUTH_TOKEN");
                System.out.println("   - TWILIO_WHATSAPP_FROM");
            }
        } catch (Exception e) {
            System.err.println("❌ Erro ao inicializar Twilio: " + e.getMessage());
            System.out.println("   Aplicação continuará funcionando sem WhatsApp");
        }
    }

    public String enviarWhatsApp(String toPhoneNumber, String messageBody) {
        try {
            if (accountSid == null || accountSid.equals("your_account_sid")) {
                System.out.println("📱 Simulando envio de WhatsApp para " + toPhoneNumber + ": " + messageBody);
                return "simulated_message_id";
            }

            String toWhatsApp = "whatsapp:" + toPhoneNumber;
            String fromWhatsApp = "whatsapp:" + fromWhatsAppNumber;

            Message message = Message.creator(
                new PhoneNumber(toWhatsApp),
                new PhoneNumber(fromWhatsApp),
                messageBody
            ).create();

            System.out.println("WhatsApp enviado com sucesso! SID: " + message.getSid());
            return message.getSid();
        } catch (Exception e) {
            System.err.println("Erro ao enviar WhatsApp: " + e.getMessage());
            System.out.println("📱 Simulando envio de WhatsApp para " + toPhoneNumber + ": " + messageBody);
            return "fallback_message_id";
        }
    }

    public String enviarSMS(String toPhoneNumber, String messageBody) {
        try {
            if (accountSid == null || accountSid.equals("your_account_sid")) {
                System.out.println("📱 Simulando envio de SMS para " + toPhoneNumber + ": " + messageBody);
                return "simulated_sms_id";
            }

            Message message = Message.creator(
                new PhoneNumber(toPhoneNumber),
                new PhoneNumber(fromWhatsAppNumber),
                messageBody
            ).create();

            System.out.println("SMS enviado com sucesso! SID: " + message.getSid());
            return message.getSid();
        } catch (Exception e) {
            System.err.println("Erro ao enviar SMS: " + e.getMessage());
            System.out.println("📱 Simulando envio de SMS para " + toPhoneNumber + ": " + messageBody);
            return "fallback_sms_id";
        }
    }
}