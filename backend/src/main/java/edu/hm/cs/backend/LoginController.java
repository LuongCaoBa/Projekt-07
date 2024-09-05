package edu.hm.cs.backend;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
public class LoginController {

    @Autowired
    private ClientRepository repository;

    @Autowired
    private TokenRepository tokenRepository;

    @Autowired
    private MailClient mailClient;

    private String MailContent = """
                                    <!DOCTYPE html>
                                        <html lang="en">
                                            <head>
                                                  <meta charset="UTF-8">
                                                    <title>Account Activation</title>
                                            </head>
                                            <body>
                                                <div style="text-align: center; margin: 20px;">
                                                    <a href="[[LINK]]" target="_blank" style="background-color: #004A99; color: white; padding: 10px 20px; text-align: center; text-decoration: none; display: inline-block; border-radius: 5px; font-size: 16px;">
                                                    Activate Account
                                                    </a>
                                                </div>
                                            </body>
                                        </html>
                                        """;

    private String RegistationPage = """
                                    <!DOCTYPE html>
                                        <html>
                                          <head>
                                            <title>ACTIVATION</title>
                                          </head>
                                          <body>
                                            <label>
                                                [[Message]]
                                            </label><br>
                                          </body>
                                        </html>
                                        """;

    private String Host = "http://localhost:8080/";

    @GetMapping("/Logger/login")
    String login(@RequestParam(name = "User-ID") Long id, @RequestParam(name = "User-name") String email, @RequestParam(name = "User-Password") String password) {
        helperfunctions helper = new helperfunctions();
        System.out.printf("Anmeldeversuch");
        if(helper.DoesEmailExist(email, repository)){
            Client client = helper.getUserByEmail(email, repository);
            if(client.getPassword().equals(password)){
                if(client.getEnabeld()){
                    JSONObject response = new JSONObject();
                    response.put("Error-bool", false);
                    response.put("message", "login successfull");
                    response.put("User-ID", client.getId());
                    response.put("User-Name", client.getUsername());
                    return response.toString();
                }
                JSONObject error = new JSONObject();
                error.put("Error-bool", true);
                error.put("Error", "Account not Activated");
                return error.toString();
            }
            JSONObject error = new JSONObject();
            error.put("Error-bool", true);
            error.put("Error", "Wrong Password");
            return error.toString();
        }
        JSONObject error = new JSONObject();
        error.put("Error-bool", true);
        error.put("Error", "User not found");
        return error.toString();
    }

    @GetMapping("/Logger/logout")
    String logout(@RequestParam(name = "User-ID") Long id) {
        return "logout";
    }

    @PostMapping("Logger/register")
    String register(@RequestBody String newUserString) {
        System.out.println("Registrierungsversuch");
        JSONObject newUserOuter = new JSONObject(newUserString);
        JSONObject newUser = new JSONObject(newUserOuter.get("content").toString());
        String username = newUser.get("User-name").toString();
        String password = newUser.get("User-Password").toString();
        String email = newUser.get("User-Email").toString();
        String StudienGang = newUser.get("Studien-Gang").toString();
        int Semester = Integer.parseInt(newUser.get("Semester").toString());
        helperfunctions helper = new helperfunctions();
        Client client = new Client(username, password, email, false, 0, Semester, StudienGang);
        if(helper.DoesEmailExist(email, repository)){
            JSONObject error = new JSONObject();
            error.put("Error-bool", true);
            error.put("Error", "Email already in Use");
            return error.toString();
        }
        repository.save(client);
        Token token = new Token(client.getId());
        tokenRepository.save(token);
        mailClient.sendMail(email, "Activate your Account!", MailContent.replace("[[LINK]]",  Host + "Logger/Activation/" + client.getId() + "/" + token.getToken()));
        JSONObject response = new JSONObject();
        response.put("Error-bool", false);
        response.put("message", "register successfull");
        response.put("User-ID", client.getId());
        response.put("User-Name", client.getUsername());
        System.out.println("UserID: " + client.getId());
        return response.toString();
    }

    @PostMapping("Logger/changePassword")
    String changePassword(@RequestParam(name = "User-ID") Long id,@RequestBody JSONObject newPassword) {
        if(repository.existsById(id)) {
            if (repository.findById(id).get().getPassword().equals(newPassword.get("User-Password").toString())) {
                repository.findById(id).get().setPassword(newPassword.get("User-Password-Neu").toString());
                JSONObject response = new JSONObject();
                response.put("Error-bool", false);
                response.put("message", "Password changed");
            }
            JSONObject error = new JSONObject();
            error.put("Error-bool", true);
            error.put("Error", "Wrong Password");
        }
        JSONObject error = new JSONObject();
        error.put("Error-bool", true);
        error.put("Error", "User not found");
        return error.toString();
    }

    @GetMapping("/Logger/Activation/{id}/{token}")
    String activation(@PathVariable Long id, @PathVariable Long token) {
        if(repository.existsById(id)){
            if(tokenRepository.existsById(token)) {
                tokenRepository.deleteById(token);
                Client client = repository.findById(id).get();
                client.setEnabeld(true);
                repository.save(client);
                return RegistationPage.replace("[[Message]]", "Account Successfully Activated, you can now login!");
            }
            return RegistationPage.replace("[[Message]]", "ERROR: Token Expired, please register again!");
        }
        return RegistationPage.replace("[[Message]]", "ERROR: User not found!");
    }

    //This is ONLY for testing purposes
    long insertUser(String username, String password, String email, boolean enabled, int role, int semester, String studiengang){
        Client client = new Client(username, password,email, enabled, role, semester, studiengang);
        repository.save(client);
        return client.getId();
    }

    //This is ONLY for testing purposes
    long createToken(long clientID) {
        Token token = new Token(clientID);
        tokenRepository.save(token);
        return token.getToken();
    }
}
