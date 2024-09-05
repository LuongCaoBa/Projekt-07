package edu.hm.cs.backend;

import org.json.JSONObject;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.util.Assert;

@SpringBootTest
public class LoginControllerTest {

    @Autowired
    public LoginController loginController;

    @Test
    void LoginTest_1(){
        long id = -1;
        loginController.insertUser("test", "test", "test@test.com", true, 0, 1, "Informatik");
        String result = loginController.login(id, "test@test.com", "test");
        JSONObject response = new JSONObject(result);
        Assert.isTrue(!response.getBoolean("Error-bool"), "Login failed");
        Assert.isTrue(response.getString("message").equals("login successfull"), "Login failed");
    }

    @Test
    void LoginTest_2(){
        long id = -1;
        loginController.insertUser("test", "test", "test@test.com", true, 0, 1, "Informatik");
        String result = loginController.login(id, "test@test.com", "test1");
        JSONObject response = new JSONObject(result);
        Assert.isTrue(response.getBoolean("Error-bool"), "Login Succeeded");
        Assert.isTrue(response.getString("Error").equals("Wrong Password"), "Wrong Error Message");
    }

    @Test
    void LoginTest_3(){
        long id = -1;
        loginController.insertUser("test", "test", "test2@test.com", false, 0,1, "Informatik");
        String result = loginController.login(id, "test2@test.com", "test1");
        JSONObject response = new JSONObject(result);
        Assert.isTrue(response.getBoolean("Error-bool"), "Login Succeeded");
        Assert.isTrue(response.getString("Error").equals("Wrong Password"), "Wrong Error Message");
    }

    @Test
    void LoginTest_4(){
        long id = -1;
        loginController.insertUser("test", "test", "test2@test.com", false, 0,1, "Informatik");
        String result = loginController.login(id, "test2@test.com", "test");
        JSONObject response = new JSONObject(result);
        Assert.isTrue(response.getBoolean("Error-bool"), "Login Succeeded");
        Assert.isTrue(response.getString("Error").equals("Account not Activated"), "Wrong Error Message");
    }

    @Test
    void LoginTest_5(){
        long id = -1;
        loginController.insertUser("test", "test", "test@test.com", true, 0,1, "Informatik");
        String result = loginController.login(id, "test@test3.com", "test");
        JSONObject response = new JSONObject(result);
        Assert.isTrue(response.getBoolean("Error-bool"), "Login Succeeded");
        Assert.isTrue(response.getString("Error").equals("User not found"), "Wrong Error Message");
    }

    @Test
    void LoginTest_6(){
        long id = -1;
        String result = loginController.login(id, "test3@test.com", "test");
        JSONObject response = new JSONObject(result);
        Assert.isTrue(response.getBoolean("Error-bool"), "Login Succeeded");
        Assert.isTrue(response.getString("Error").equals("User not found"), "Wrong Error Message");

    }

    @Test
    void RegisterTest_1(){
        loginController.insertUser("test", "test", "test@test.com", true, 0,1, "Informatik");
        JSONObject start = new JSONObject();
        start.put("User-name", "test");
        start.put("User-Password", "test");
        start.put("User-Email", "stadix@gmx.net");  //isert a valid email here in order to Receive the activation link
        start.put("Studien-Gang", "Informatik");
        start.put("Semester", 1);
        JSONObject outer = new JSONObject();
        outer.put("content", start);
        String result = loginController.register(outer.toString());
        JSONObject response = new JSONObject(result);
        Assert.isTrue(!response.getBoolean("Error-bool"), "Register Failed");
        Assert.isTrue(response.getString("message").equals("register successfull"), "Register Failed");
    }

    @Test
    void RegisterTest_2(){
        JSONObject start = new JSONObject();
        start.put("User-name", "test");
        start.put("User-Password", "test");
        start.put("User-Email", "fstadler@hm.edu");  //isert a valid email here in order to Receive the activation link
        start.put("Studien-Gang", "Informatik");
        start.put("Semester", 1);
        JSONObject outer = new JSONObject();
        outer.put("content", start);
        String result = loginController.register(outer.toString());
        JSONObject response = new JSONObject(result);
        Assert.isTrue(!response.getBoolean("Error-bool"), "Register Failed");
        Assert.isTrue(response.getString("message").equals("register successfull"), "Register Failed");
    }

    @Test
    void RegisterTest_3(){
        loginController.insertUser("test", "test", "test@test.com", true, 0,1, "Informatik");
        JSONObject start = new JSONObject();
        start.put("User-name", "test");
        start.put("User-Password", "test");
        start.put("User-Email", "test@test.com");
        start.put("Studien-Gang", "Informatik");
        start.put("Semester", 1);
        JSONObject outer = new JSONObject();
        outer.put("content", start);
        String result = loginController.register(outer.toString());
        JSONObject response = new JSONObject(result);
        Assert.isTrue(response.getBoolean("Error-bool"), "Register Succeeded");
        Assert.isTrue(response.getString("Error").equals("Email already in Use"), "Wrong Error Message");
    }

    @Test
    void ActivationTest_1(){
        long id = loginController.insertUser("test", "test", "test@test.com", true, 0,1, "Informatik");
        long token = loginController.createToken(id);
        String result = loginController.activation(id, token);
        Assert.isTrue(result.equals("<!DOCTYPE html>\n" +
                "    <html>\n" +
                "      <head>\n" +
                "        <title>ACTIVATION</title>\n" +
                "      </head>\n" +
                "      <body>\n" +
                "        <label>\n" +
                "            Account Successfully Activated, you can now login!\n" +
                "        </label><br>\n" +
                "      </body>\n" +
                "    </html>\n"), "Activation Failed");

    }

    @Test
    void ActivationTest_2(){
        long invalid = -1;
        long id = loginController.insertUser("test", "test", "test@test.com", true, 0,1, "Informatik");
        long token = loginController.createToken(id);
        String result = loginController.activation(id, invalid);
        Assert.isTrue(result.equals("<!DOCTYPE html>\n" +
                "    <html>\n" +
                "      <head>\n" +
                "        <title>ACTIVATION</title>\n" +
                "      </head>\n" +
                "      <body>\n" +
                "        <label>\n" +
                "            ERROR: Token Expired, please register again!\n" +
                "        </label><br>\n" +
                "      </body>\n" +
                "    </html>\n"), "Wrong Answer");
    }

    @Test
    void ActivationTest_3(){
        long invalid = -1;
        long id = loginController.insertUser("test", "test", "test@test.com", true, 0,1, "Informatik");
        long token = loginController.createToken(id);
        String result = loginController.activation(invalid, invalid);
        Assert.isTrue(result.equals("<!DOCTYPE html>\n" +
                "    <html>\n" +
                "      <head>\n" +
                "        <title>ACTIVATION</title>\n" +
                "      </head>\n" +
                "      <body>\n" +
                "        <label>\n" +
                "            ERROR: User not found!\n" +
                "        </label><br>\n" +
                "      </body>\n" +
                "    </html>\n"), "Wrong Answer");
    }

    @Test
    void ActivationTest_4(){
        long invalid = -1;
        String result = loginController.activation(invalid, invalid);
        Assert.isTrue(result.equals("<!DOCTYPE html>\n" +
                "    <html>\n" +
                "      <head>\n" +
                "        <title>ACTIVATION</title>\n" +
                "      </head>\n" +
                "      <body>\n" +
                "        <label>\n" +
                "            ERROR: User not found!\n" +
                "        </label><br>\n" +
                "      </body>\n" +
                "    </html>\n"), "Wrong Answer");
    }
}
