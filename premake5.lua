dependencies = {
	basePath = "./deps"
}

function dependencies.load()
	dir = path.join(dependencies.basePath, "premake/*.lua")
	deps = os.matchfiles(dir)

	for i, dep in pairs(deps) do
		dep = dep:gsub(".lua", "")
		require(dep)
	end
end

function dependencies.imports()
	for i, proj in pairs(dependencies) do
		if type(i) == 'number' then
			proj.import()
		end
	end
end

function dependencies.projects()
	for i, proj in pairs(dependencies) do
		if type(i) == 'number' then
			proj.project()
		end
	end
end

dependencies.load()

workspace "t6-gsc-utils"
	startproject "t6-gsc-utils"
	location "./build"
	objdir "%{wks.location}/obj"
	targetdir "%{wks.location}/bin/%{cfg.platform}/%{cfg.buildcfg}"
	
	configurations { "Debug", "Release" }
	
	architecture "x86"
	platforms "win32"
	
	disablewarnings 
	{
		"6031",
		"6053",
		"26495",
		"26812",
	}

	buildoptions "/std:c++latest"
	systemversion "latest"
	defines { "_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS" }
	
	configuration "windows"
		defines { "_WINDOWS", "WIN32" }
		staticruntime "On"
		
		if symbols ~= nil then
			symbols "On"
		else
			flags { "Symbols" }
		end

	configuration "Release"
		defines { "NDEBUG" }
		flags { "MultiProcessorCompile", "LinkTimeOptimization", "No64BitChecks" }
		optimize "Full"

	configuration "Debug"
		defines { "DEBUG", "_DEBUG" }
		flags { "MultiProcessorCompile", "No64BitChecks" }
		optimize "Debug"

	project "t6-gsc-utils"
		kind "SharedLib"
		language "C++"
		
		files 
		{
			"./src/**.h",
			"./src/**.hpp",
			"./src/**.cpp",
		}
		
		includedirs 
		{
			"%{prj.location}/src",
			"./src",
		}
		
		resincludedirs 
		{
			"$(ProjectDir)src"
		}
				
		pchheader "stdinc.hpp"
		pchsource "src/stdinc.cpp"
		buildoptions { "/Zm100 -Zm100" }

		flags { "UndefinedIdentifiers" }
		warnings "Off"
		
		configuration "Release"
			flags { "FatalCompileWarnings" }
			
		configuration {}

		dependencies.imports()
	
	group "Dependencies"
	dependencies.projects()