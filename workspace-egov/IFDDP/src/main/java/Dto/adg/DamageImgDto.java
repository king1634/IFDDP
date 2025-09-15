package Dto.adg;

import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class DamageImgDto {
	private int damageId; // 손상 식별자
	private int ord; // 순서
	private String fileName; // 파일명
}
