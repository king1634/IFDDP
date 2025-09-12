package Dto.adg;

import lombok.Data;

@Data
public class BunryuDto {
	private int bcd;          // 대분류
	private int mcd;          // 중분류
	private String contents;  // 내용
}
