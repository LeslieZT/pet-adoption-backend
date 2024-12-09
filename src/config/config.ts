import dotenv from "dotenv";

dotenv.config();

export const config = () => ({
	PORT: process.env.PORT || 3000,
	SALT_ROUNDS: process.env.SALT_ROUNDS || "10",
	NODE_ENV: process.env.NODE_ENV || "local",
	DATABASE_URL: process.env.DATABASE_URL,	
	URL_SUPABASE: process.env.URL_SUPABASE || "",
	ANON_KEY_SUPABASE: process.env.ANON_KEY_SUPABASE || "",
	BREVO_EMAIL_FROM: process.env.BREVO_EMAIL_FROM || "",
	BREVO_SMTP_HOST: process.env.BREVO_SMTP_HOST || "",
	BREVO_SMTP_PASS: process.env.BREVO_SMTP_PASS || "",
	BREVO_SMTP_PORT: process.env.BREVO_SMTP_PORT || "587",
	BREVO_SMTP_USER: process.env.BREVO_SMTP_USER || "",
	FRONTEND_URL: process.env.FRONTEND_URL || "http://localhost:5173",
	BACKEND_URL: process.env.BACKEND_URL || "http://localhost:3000",
	STRIPE_SECRET_KEY: process.env.STRIPE_SECRET_KEY || "",
	CLOUDINARY_API_KEY: process.env.CLOUDINARY_API_KEY,
	CLOUDINARY_API_SECRET: process.env.CLOUDINARY_API_SECRET,
	CLOUDINARY_CLOUD_NAME: process.env.CLOUDINARY_CLOUD_NAME


});
