export interface UploadResponse {
	secure_url: string;
	public_id: string;
}

export interface StorageAdapter {
	uploadFile(file: Buffer, folder: string): Promise<UploadResponse>;
	deleteFile(key: string): Promise<any>;
}
