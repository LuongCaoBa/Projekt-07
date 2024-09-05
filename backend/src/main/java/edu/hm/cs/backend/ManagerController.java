package edu.hm.cs.backend;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.BufferedReader;
import java.io.StringReader;
import java.util.*;

@RestController
public class ManagerController {

    @Autowired
    public GroupRepository repository;

    @Autowired
    public ClientRepository clientRepository;

    @PostMapping("/manager")
    String SetAutoGroups(@RequestParam(name = "StudienGang")String Studiengang,  @RequestBody String message) {
        List<List<String>> records = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new StringReader(message))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] values = line.split(",");
                records.add(Arrays.asList(values));
            }
        } catch (Exception e) {
            JSONObject response = new JSONObject();
            response.put("Error-bool", true);
            response.put("Error-Message", "Wrong Format");
            return response.toString();

        }
        List<String> Subjects = new ArrayList<>();
        Map<Integer, List<String>> SemesterMap = new HashMap<>();
        Map<String, Long> SubjectIDMap = new HashMap<>();

        for(int i = 0; i < records.size(); i++){
            List<String> Semester = new ArrayList<>();
            if(records.get(i).size() < 2){
                JSONObject response = new JSONObject();
                response.put("Error-bool", true);
                response.put("Error-Message", "Wrong Format");
                return response.toString();
            }
            for(int j = 0; j < records.get(i).size(); j++){
                if(Subjects.contains(records.get(i).get(j))){
                    continue;
                }
                Subjects.add(records.get(i).get(j));
                Group group = new Group(records.get(i).get(j));
                long id = repository.save(group).getId();
                Semester.add(records.get(i).get(j));
                SubjectIDMap.put(records.get(i).get(j), id);
            }
            SemesterMap.put(i+1, Semester);
        }

        List<Client> clients = clientRepository.findAll();
        for(int i = 0; i < clients.size(); i++){
            if(clients.get(i).getStudiengang().equals(Studiengang)){
                List<String> SemesterSubjects = SemesterMap.get(clients.get(i).getSemester());
                for(int j = 0; j < SemesterSubjects.size(); j++){
                    long id = SubjectIDMap.get(SemesterSubjects.get(j));
                    clients.get(i).addToGroup(repository.findById(id).get());
                    repository.findById(id).get().addClient(clients.get(i));
                }
            }
        }

        JSONObject response = new JSONObject();
        response.put("Error-bool", false);
        response.put("Error-Message", "");
        return response.toString();
    }
}
