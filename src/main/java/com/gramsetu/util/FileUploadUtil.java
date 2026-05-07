package com.gramsetu.util;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.*;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

/**
 * Handles file uploads for crop photos and soil advisory images.
 *
 * Upload directory is resolved in priority order:
 *   1. UPLOAD_DIR environment variable (set this on Render)
 *   2. System property "upload.dir"
 *   3. Fallback: ~/gramsetu-uploads/ (local dev only)
 *
 * Files are served via the /uploads/** URL mapping configured in web.xml.
 */
@Component
public class FileUploadUtil {

    private static final List<String> ALLOWED_EXTENSIONS =
        Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp", ".avif");

    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10 MB

    /** Returns the absolute path to the upload root directory. */
    public static String getUploadBasePath() {
        String env = System.getenv("UPLOAD_DIR");
        if (env != null && !env.isBlank()) return env.endsWith("/") ? env : env + "/";
        String prop = System.getProperty("upload.dir");
        if (prop != null && !prop.isBlank()) return prop.endsWith("/") ? prop : prop + "/";
        return System.getProperty("user.home") + "/gramsetu-uploads/";
    }

    /**
     * Saves the uploaded file into BASE/folder/ and returns the relative URL
     * that can be used in HTML src attributes, e.g. /uploads/crops/uuid.jpg
     *
     * @param file   the incoming multipart file
     * @param folder sub-directory name ("crops" | "soil")
     * @return relative URL, or null if file is empty
     */
    public String uploadFile(MultipartFile file, String folder) throws IOException {
        if (file == null || file.isEmpty()) return null;

        // Validate file size
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("File too large. Maximum allowed size is 10 MB.");
        }

        // Validate extension
        String original = file.getOriginalFilename();
        if (original == null || original.isBlank()) {
            throw new IllegalArgumentException("Invalid file name.");
        }
        // Sanitize: strip path traversal attempts
        original = Paths.get(original).getFileName().toString();

        String ext = "";
        int dot = original.lastIndexOf('.');
        if (dot >= 0) ext = original.substring(dot).toLowerCase();

        if (!ALLOWED_EXTENSIONS.contains(ext)) {
            throw new IllegalArgumentException(
                "Only image files are allowed (jpg, jpeg, png, gif, webp, avif). Got: " + ext);
        }

        // Validate MIME type as secondary check
        String contentType = file.getContentType();
        if (contentType != null && !contentType.startsWith("image/")) {
            throw new IllegalArgumentException("Uploaded file does not appear to be an image.");
        }

        // Create target directory
        String base = getUploadBasePath();
        Path dir = Paths.get(base + folder);
        Files.createDirectories(dir);

        // Generate unique file name to prevent overwrites
        String fileName = UUID.randomUUID() + ext;
        Path target = dir.resolve(fileName);
        Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);

        return "/uploads/" + folder + "/" + fileName;
    }

    /**
     * Deletes a previously uploaded file given its relative URL.
     */
    public void deleteFile(String relUrl) {
        if (relUrl == null || relUrl.isBlank()) return;
        try {
            String base = getUploadBasePath();
            Path target = Paths.get(base + relUrl.replace("/uploads/", ""));
            Files.deleteIfExists(target);
        } catch (IOException ignored) {}
    }
}
