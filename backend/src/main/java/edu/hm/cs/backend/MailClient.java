package edu.hm.cs.backend;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.apache.logging.log4j.message.Message;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailSendException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.MimeMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service("mailClient")
public class MailClient {

    private JavaMailSender javaMailSender;

    @Autowired
    public MailClient(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    @Async
    public boolean sendMail(String to, String subject, String text) {
        try {

            MimeMessage message = javaMailSender.createMimeMessage();
            message.setFrom("SEproject07@gmx.net");
            message.setRecipients(MimeMessage.RecipientType.TO, to);
            message.setSubject(subject);
            message.setContent(text, "text/html; charset=utf-8");
            javaMailSender.send(message);

        } catch (MessagingException | MailSendException e){
            return false;
        }

        return true;
    }
}
