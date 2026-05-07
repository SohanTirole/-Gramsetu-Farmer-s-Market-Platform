package com.gramsetu.service;

import com.gramsetu.dao.CropDAO;
import com.gramsetu.model.Crop;
import com.gramsetu.util.FileUploadUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
public class CropService {

    @Autowired private CropDAO cropDAO;
    @Autowired private FileUploadUtil fileUploadUtil;

    public List<Crop> getAll()                                        { return cropDAO.findAll(); }
    public List<Crop> search(String kw, String cat, String st)        { return cropDAO.search(kw, cat, st); }
    public Crop getById(int id)                                       { return cropDAO.findById(id); }
    public List<Crop> getByFarmer(int fid)                            { return cropDAO.findByFarmerId(fid); }
    public int countByFarmer(int fid)                                 { return cropDAO.countByFarmerId(fid); }
    public int totalCount()                                           { return cropDAO.totalCount(); }

    @Transactional
    public int addCrop(Crop crop, MultipartFile photo) {
        uploadPhoto(crop, photo);
        return cropDAO.save(crop);
    }

    @Transactional
    public void updateCrop(Crop crop, MultipartFile photo) {
        uploadPhoto(crop, photo);
        cropDAO.update(crop);
    }

    @Transactional
    public void deleteCrop(int id, int farmerId) { cropDAO.delete(id, farmerId); }

    private void uploadPhoto(Crop crop, MultipartFile photo) {
        if (photo != null && !photo.isEmpty()) {
            try { crop.setPhotoUrl(fileUploadUtil.uploadFile(photo, "crops")); }
            catch (Exception e) { System.err.println("Photo upload failed: " + e.getMessage()); }
        }
    }
}
