import multer from "multer";

const storage = multer.memoryStorage();

export const uploadMulterStorage = multer({ storage: storage });
