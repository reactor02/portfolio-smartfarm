package kr.or.smartfarm.usermanage;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA256Util {
	
	 public static String encrypt(String rawText) {
	        if (rawText == null) {
	            return null;
	        }
	        
	        try {
	            // 1. SHA-256 알고리즘 인스턴스 생성
	            MessageDigest md = MessageDigest.getInstance("SHA-256");
	            
	            // 2. 평문 문자열을 바이트 배열로 변환하여 해시 적용 [1]
	            md.update(rawText.getBytes());
	            byte[] byteData = md.digest();
	            
	            // 3. 바이트 배열을 16진수 문자열(Hex String)로 변환
	            StringBuilder sb = new StringBuilder();
	            for (byte b : byteData) {
	                sb.append(String.format("%02x", b));
	            }
	            
	            // 4. 최종 64글자 암호화 문자열 리턴
	            return sb.toString();
	            
	        } catch (NoSuchAlgorithmException e) {
	            // 알고리즘 이름이 잘못되었을 때 예외 처리
	            e.printStackTrace();
	            throw new RuntimeException("SHA-256 암호화 중 오류가 발생했습니다.");
	        }
	    }

}
