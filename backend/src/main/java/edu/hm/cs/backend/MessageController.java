package edu.hm.cs.backend;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RestController
public class MessageController {

    @Autowired
    public GroupRepository repository;

    @Autowired
    public helperfunctions helper;

    @GetMapping("/messages")
    String allMessages(@RequestParam(name = "User-ID") long id, @RequestParam(name = "destID") long destID, @RequestParam(name = "Chunk-ID") long ChunkID) {
        List<Message> messages = null;
        if(helper.isGroupIDFound(destID)){
            messages = helper.getMessageByGroupID(destID);
        }
//        else if(helper.isUserIDFound(destID)){
//            messages = helper.getMessageByUserID(destID, id);
//        }
        else{
            JSONObject response = new JSONObject();
            response.put("Error-bool", true);
            response.put("Error-Message", "No User or Group with this ID found");
            return response.toString();
        }
        List<JSONObject> messageArray = new ArrayList<>();
        for(int i = 0; i < messages.size(); i++){
            JSONObject message = new JSONObject();
            message.put("Message-Content", messages.get(i).getContent());
            message.put("Message-Sender", messages.get(i).getSender());
            message.put("Message-Timestamp", messages.get(i).getTimestamp());
            messageArray.add(message);
        }
        JSONObject response = new JSONObject();
        response.put("Error-bool", false);
        response.put("Error-Message", "");
        response.put("Messages", messageArray);
        return response.toString();
    }

    @PostMapping("/messages/send")
    String sendMessage(@RequestParam(name = "User-ID") long id, @RequestParam(name = "destID") long destID, @RequestParam(name = "Group") boolean isGroup, @RequestParam(name = "ReleaseDate") String ReleaseDate , @RequestBody String message) {
        MessageRepository repo = helper.getMessageRepo();
        String[] date = ReleaseDate.split("-");
        if(date.length != 6){
            JSONObject error = new JSONObject();
            error.put("Error-bool", true);
            error.put("Error-Message", "Wrong Date Format");
            return error.toString();
        }
        Date OpenDate = new Date(Integer.parseInt(date[0]),Integer.parseInt(date[1]),Integer.parseInt(date[2]), Integer.parseInt(date[3]),Integer.parseInt(date[4]),Integer.parseInt(date[5]));
        Date timestamp = Date.from(Instant.now());
        String dates = (timestamp.getYear() + 1900) + "-" + (timestamp.getMonth() + 1) + "-" + timestamp.getDate() + " " + timestamp.getHours() + ":" + timestamp.getMinutes() + ":" + timestamp.getSeconds() + "Z";
        String ChatID = destID + "#" + id;
        Message newMessage = new Message(message, helper.getUserByID(id).getUsername(), isGroup, destID, ChatID, dates, OpenDate);
        repo.save(newMessage);
        JSONObject response = new JSONObject();
        response.put("Error-bool", false);
        response.put("Error-Message", "");
        return response.toString();
    }
}
