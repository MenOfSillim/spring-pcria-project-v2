package com.example.pcria;

import javax.servlet.http.Part;
import java.io.File;

public class FileUtils {
    public static void makeFolder(String path) {
        File dir = new File(path);
        if(!dir.exists()) {
            dir.mkdirs();
        }
    }
    public static String getExt(String fileNm) {
        return fileNm.substring(fileNm.lastIndexOf("."));
    }
    public static String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
    public static boolean delFile(String path) {
        File file = new File(path);
        if(file.exists()) {
            return file.delete();
        }
        return false;
    }
}
