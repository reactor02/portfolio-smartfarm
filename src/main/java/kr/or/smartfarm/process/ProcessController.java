package kr.or.smartfarm.process;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.http.HttpHeaders;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.github.pagehelper.PageInfo;

import kr.or.smartfarm.bom.BomDTO;
import kr.or.smartfarm.stock.StockDTO;


@Controller
public class ProcessController {

	@Autowired
	ProcessService Service;
	//처음 들어오는 페이지 (목록)
	@RequestMapping("/process")
	public String bomSelect(@RequestParam(value = "page", defaultValue = "1")int page,@RequestParam(value="msg", required=false)String msg,Model model) {
		List result = null;
		 result = Service.selectAll(page);
		 model.addAttribute("result" , result);
		 
		 PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(result);
		 model.addAttribute("pageInfo", pageInfo);
		return "content/processSelect.tiles";
	}

	// ProcessController.java
	@RequestMapping("/processDetail")
	public String Detail(@RequestParam(value="process_num", required=false) int Num, Model model) {
	    // List 타입을 ProcessDTO가 아니라 Object나 Map으로 받아야 해
	    List<Map<String, Object>> result = Service.selectDetail(Num); 
	    
	    if (result != null && !result.isEmpty()) {
	        String uploadPath = "D:\\workspace\\workspace_java\\Zmartfarm\\src\\main\\webapp\\WEB-INF\\views\\processImg";
	        for (Map<String, Object> map : result) {
	        	System.out.println("DEBUG - Map 전체 데이터: " + map);

	            // map.get("savedFileName")으로 접근
	            String fileName = (String) map.get("IMAGE"); 
	            System.out.println("!!!!!!파일명 확인: " + fileName);
	            if (fileName != null && !fileName.isEmpty()) {
	                try (InputStream in = new FileInputStream(uploadPath + fileName)) {
	                    byte[] imageBytes = IOUtils.toByteArray(in);
	                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
	                    map.put("base64Image", base64Image); 
	                } catch (Exception e) {
	                    e.printStackTrace();
	                }
	            }
	        }
	    }
	    
	    model.addAttribute("resultList", result);
	    return "content/processDetail.tiles";
	}

	

	
	//검색 버튼 눌러서 검색
	//검색 버튼으로 검색했을 때
		@RequestMapping("/searchProcess") 
		@ResponseBody
		public Map searchStocks(
		        @RequestParam(value = "page", defaultValue = "1") int page,
		        @RequestParam(value = "type") String type,
		        @RequestParam(value = "keyword") String keyword,
		        @RequestParam(value = "process_status") String process_status
		        ) {
			System.out.println("process_status===" + process_status);
		    Map result = new HashMap();
		    
		    try {
		        Map searchMap = new HashMap();
		        searchMap.put("page", page);
		        searchMap.put("type", type);
		        searchMap.put("keyword", keyword );
		        searchMap.put("process_status", process_status);
	System.out.println(searchMap);
		        
		        List searchResult = Service.searchProcess(searchMap);
		        result.put("searchResult", searchResult);

		        result.put("status", "good");
		        if(searchResult != null) {
		        	PageInfo<Map<String, Object>> pageInfo = new PageInfo<Map<String, Object>>(searchResult);
		        	result.put("pageInfo", pageInfo);
		        }else {
		        	PageInfo pageInfo = new PageInfo();
		        	result.put("pageInfo", pageInfo);
		        }
		        
		    } catch(Exception e) {
		        e.printStackTrace();
		        result.put("status", "error");
		    }
		    
		    return result;
		}
		
		//모달에서 검색
		@RequestMapping("/processModal")
		@ResponseBody
		public Map modal(@RequestParam(value = "search")String keyword) {
			Map result = null;
			System.out.println(keyword);
			result = Service.modalSearch(keyword);
			return result;
		}
		
		//모달 등록
		@RequestMapping("/PinsertController")
		public String insertController(ProcessDTO dto, Model model) {
			String uploadFolder = "D:\\workspace\\workspace_java\\Zmartfarm\\src\\main\\webapp\\WEB-INF\\views\\processImg";
			
			if (dto.getImage() != null && !dto.getImage().isEmpty()) {
		        
		        // 2. 파일 저장 로직 ( UUID 방식 사용)
		        String fileName = UUID.randomUUID().toString() + "_" + dto.getImage().getOriginalFilename();
		        File saveFile = new File(uploadFolder, fileName);
		        
		        try {
		            dto.getImage().transferTo(saveFile);
		            
		            // 3. DB에는 실제 파일명(String)만 넣어야 하므로 따로 세팅
		            dto.setSavedFileName(fileName);
		            
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }
			
			Service.insertProcess(dto);
			return "redirect:/process";
		}
		
		@PostMapping("/PupdateStatus")
		public String updateStatus(ProcessDTO dto) {
		    
		    // 1. DTO에서 업로드된 파일 가져오기
		    MultipartFile uploadFile = dto.getImage();

		    // 2. 파일이 새로 업로드 되었는지 확인
		    if (uploadFile != null && !uploadFile.isEmpty()) {
		        
		        String originalFileName = uploadFile.getOriginalFilename();
		        
		        // 파일명 중복을 방지하기 위해 UUID(고유 식별자) 생성 후 원래 이름과 결합
		        String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
		        
		        String uploadPath = "D:\\workspace\\workspace_java\\Zmartfarm\\src\\main\\webapp\\WEB-INF\\views\\processImg"; 
		        
		        File saveFile = new File(uploadPath, savedFileName);
		        
		        try {
		            // 저장할 폴더가 없으면 자동 생성
		            if (!saveFile.getParentFile().exists()) {
		                saveFile.getParentFile().mkdirs();
		            }
		            
		            // 3. 지정된 경로에 실제 물리적 파일 저장
		            uploadFile.transferTo(saveFile);
		            
		            // 4. DB에 업데이트하기 위해 새 파일명을 DTO에 세팅
		            dto.setSavedFileName(savedFileName);
		            
		        } catch (IOException e) {
		            System.out.println("이미지 파일 저장 중 에러 발생: " + e.getMessage());
		            e.printStackTrace();
		            // 필요 시 에러 페이지로 리다이렉트 하는 로직 추가 가능
		        }
		    }

		    // 5. Service를 호출하여 DB 업데이트 수행 (수정된 DTO 전달)
		    Service.updateStatus(dto);
		    
		    // 6. 업데이트 완료 후 원래의 상세 페이지로 리다이렉트
		    return "redirect:/processDetail?process_num=" + dto.getProcess_num();
		}
		
		
		
		}
