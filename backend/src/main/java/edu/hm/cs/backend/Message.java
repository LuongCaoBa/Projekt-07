package edu.hm.cs.backend;

import ch.qos.logback.core.joran.sanity.Pair;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

import java.util.Date;

@Entity
public class Message {


    private @GeneratedValue @Id Long messageID;

    boolean isGroupMessage;

    private Long groupID;
    private String content;
    private String sender;
    private String ChatID;

    private String timestamp;

    private Date releaseDate;

    public Message() {
    }

    public Message(String content, String sender, boolean isGroupMessage, Long groupID, String chatID, String timestamp, Date releaseDate) {
        this.content = content;
        this.sender = sender;
        this.isGroupMessage = isGroupMessage;
        this.groupID = groupID;
        this.ChatID = chatID;
        this.timestamp = timestamp;
        this.releaseDate = releaseDate;
    }

    public Long getMessageID() {
        return messageID;
    }

    public boolean isGroupMessage() {
        return isGroupMessage;
    }

    public Long getGroupID() {
        return groupID;
    }

    public String getContent() {
        return content;
    }

    public String getSender() {
        return sender;
    }

    public String getChatID() {
        return ChatID;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

}
