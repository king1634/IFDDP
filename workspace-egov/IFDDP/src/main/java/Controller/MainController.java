package Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MainController {
	
    @RequestMapping("/")
    public String main(Model model) {
    	System.out.println("main");
    	
    	return "redirect:/agingPattern.do";
    }
}
