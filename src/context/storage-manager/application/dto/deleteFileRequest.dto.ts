import { ArrayMinSize, IsArray, IsString } from "class-validator";

export class DeleteFileRequestDto {
	@IsString({ each: true })
	@ArrayMinSize(1)
	@IsArray()
	keys: string[];
}
