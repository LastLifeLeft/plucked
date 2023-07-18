EnableExplicit
UseZipPacker()

#StringToInsert = ~"// Feather disable all\n"

Define *Buffer, Size, Temp.s, File.s, StringByteLength
       
File.s = OpenFileRequester("Plucked - Choose a library to process", "", "GM Package (*.yymps)|*.yymps", 0)

If OpenPack(0, File, #PB_PackerPlugin_Zip)
	StringByteLength = StringByteLength(#StringToInsert, #PB_UTF8)
	CreatePack(1, GetPathPart(File) + GetFilePart(File, #PB_FileSystem_NoExtension) + "_Plucked.yymps", #PB_PackerPlugin_Zip)
	Temp = GetEnvironmentVariable("TEMP")
	
	If Right(Temp, 1) <> "\" And Right(Temp, 1) <> "/"
		Temp + "\"
	EndIf

	If ExaminePack(0)
		While NextPackEntry(0)
			If PackEntryType(0) = #PB_Packer_File And LCase(GetFilePart(PackEntryName(0))) <> "yymanifest.xml"
				Size = PackEntrySize(0)
				If LCase(GetExtensionPart(PackEntryName(0))) = "gml"
					*Buffer = AllocateMemory(Size + StringByteLength)
					PokeS(*Buffer, #StringToInsert, -1, #PB_UTF8)
					UncompressPackMemory(0, *Buffer + StringByteLength, Size)
					Size + StringByteLength
				Else
					*Buffer = AllocateMemory(Size)
					UncompressPackMemory(0, *Buffer, Size)
				EndIf
				AddPackMemory(1, *Buffer, Size, PackEntryName(0))
				FreeMemory(*Buffer)
			EndIf
		Wend
	EndIf
	ClosePack(0)
	ClosePack(1)
	
	RunProgram("explorer", ~"/Select, \""+GetPathPart(File) + GetFilePart(File, #PB_FileSystem_NoExtension) + "_Plucked.yymps" + ~"\"", "")
EndIf
; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; CursorPosition = 39
; EnableXP
; DPIAware
; Executable = ..\Plucked.exe
; Compiler = PureBasic 6.02 LTS - C Backend (Windows - x64)