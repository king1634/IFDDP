package Controller.kkm;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class AgingPatternController {

	@GetMapping("agingPattern.do")
	public String startAgingPattern() {
		
		return "agingPattern";
	}
}
