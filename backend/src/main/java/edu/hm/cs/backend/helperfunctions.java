package edu.hm.cs.backend;

import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;

@Service
public class helperfunctions {

    @Autowired
    public GroupRepository repository;

    @Autowired
    public ClientRepository clientRepository;

    @Autowired
    public TokenRepository tokenRepository;

    @Autowired
    public MessageRepository messageRepository;

    public boolean DoesEmailExist(String email, ClientRepository clientRepository) {
        AtomicReference<Boolean> found = new AtomicReference<>(false);
        List<Client> clients = clientRepository.findAll();
        Iterator<Client> ueriterator = clients.stream().iterator();
        while (ueriterator.hasNext()) {
            Client client = ueriterator.next();
            if (client.getEmail().equals(email)) {
                found.set(true);
                break;
            }
        }
        return found.get();
    }

    public Client getUserByEmail(String email, ClientRepository clientRepository) {
        AtomicReference<Client> found = new AtomicReference<>(null);
        clientRepository.findAll().forEach(client -> {
            if (client.getEmail().equals(email)) {
                found.set(client);
                return;
            }
        });
        return found.get();
    }

    public boolean isTokenExpiered(Token token) {
        return token.getExpirationDate() < System.currentTimeMillis();
    }

    public boolean isGroupIDFound(Long id) {
        AtomicReference<Boolean> found = new AtomicReference<>(false);
        List<Group> groups = repository.findAll();
        Iterator<Group> groupIterator = groups.stream().iterator();
        while (groupIterator.hasNext()) {
            Group group = groupIterator.next();
            if (group.getId().equals(id)) {
                found.set(true);
                break;
            }
        }
        return found.get();
    }

    public List<Group> allGroups() {
        return repository.findAll();
    }

    public Group getGroupById(long groupId) {
        return repository.findById(groupId)
                .orElseThrow(() -> new GroupNotFoundException(groupId));
    }

    public List<Message> getMessageByGroupID(long GroupID) {
        List<Message> result = new ArrayList<>();
        List<Message> messages = messageRepository.findAll();
        Iterator<Message> messageIterator = messages.stream().iterator();
        while (messageIterator.hasNext()) {
            Message message = messageIterator.next();
            if (message.getGroupID() == GroupID && message.isGroupMessage() ) {
                result.add(message);
            }
        }
        return result;
    }

    public boolean isUserIDFound(long destID) {
        AtomicReference<Boolean> found = new AtomicReference<>(false);
        List<Client> clients = clientRepository.findAll();
        Iterator<Client> clientIterator = clients.stream().iterator();
        while (clientIterator.hasNext()) {
            Client client = clientIterator.next();
            if (client.getId().equals(destID)) {
                found.set(true);
                break;
            }
        }
        return found.get();
    }

    public List<Message> getMessageByUserID(long destID, long userID) {
        List<Message> result = new ArrayList<>();
        List<Message> messages = messageRepository.findAll();
        Iterator<Message> messageIterator = messages.stream().iterator();
        while (messageIterator.hasNext()) {
            Message message = messageIterator.next();
            if ((message.getChatID().equals(destID + "#" + userID) || message.getChatID().equals(userID + "#" + destID) )&& !message.isGroupMessage()) {
                result.add(message);
            }
        }
        return result;
    }

    public MessageRepository getMessageRepo(){
        return messageRepository;
    }

    public Client getUserByID(long id) {
        Client client = clientRepository.findById(id).orElse(null);
        return client;
    }
}
