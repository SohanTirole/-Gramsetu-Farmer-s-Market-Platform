package com.gramsetu.config;

import com.gramsetu.util.FileUploadUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

/**
 * Serves user-uploaded files from the configurable UPLOAD_DIR.
 * Maps /uploads/folder/filename.ext → UPLOAD_DIR/folder/filename.ext
 *
 * This is needed because the upload directory is OUTSIDE the webapp,
 * so Tomcat cannot serve it as a static resource automatically.
 */

public class UploadsServlet extends HttpServlet {

    private static final Map<String, String> MIME_TYPES = new HashMap<>();
    static {
        MIME_TYPES.put(".jpg",  "image/jpeg");
        MIME_TYPES.put(".jpeg", "image/jpeg");
        MIME_TYPES.put(".png",  "image/png");
        MIME_TYPES.put(".gif",  "image/gif");
        MIME_TYPES.put(".webp", "image/webp");
        MIME_TYPES.put(".avif", "image/avif");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // pathInfo is like /crops/uuid.jpg
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.contains("..")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String base = FileUploadUtil.getUploadBasePath();
        // Remove leading slash from pathInfo before resolving
        Path file = Paths.get(base).resolve(pathInfo.substring(1)).normalize();

        // Prevent path traversal: resolved path must start with base
        if (!file.startsWith(Paths.get(base).normalize())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!Files.exists(file) || !Files.isRegularFile(file)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String name = file.getFileName().toString().toLowerCase();
        String ext  = name.contains(".") ? name.substring(name.lastIndexOf('.')) : "";
        String mime = MIME_TYPES.getOrDefault(ext, "application/octet-stream");

        resp.setContentType(mime);
        resp.setHeader("Cache-Control", "public, max-age=86400");
        resp.setContentLengthLong(Files.size(file));

        try (OutputStream out = resp.getOutputStream()) {
            Files.copy(file, out);
        }
    }
}
