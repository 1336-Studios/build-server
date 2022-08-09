import subprocess, os

build_string = "GridIron"
hash = "e9180fa"


depot64_config = '''
"DepotBuildConfig"
{{
"DepotID" "1535872"

"ContentRoot"	"C:\Builds\{build_string}\{hash}\WindowsClient"

"FileMapping"
{{
    "LocalPath" "*"
    "DepotPath" "."

    "recursive" "1"
}}

"FileExclusion" "*.pdb"
}}
'''

app_config = '''
"appbuild"
{{
"appid" "1535870"

"desc" "{build_string}-{hash}"

"preview" "0"

"local" ""

"setlive" ""

"buildoutput" "C:\\steam\\tools\\ContentBuilder\\output"

"contentroot" "C:\\steam\\tools\\ContentBuilder\\content"

"depots"
{{
    "1535872" "depot_{build_string}_64.vdf"
}}
}}
'''




with open("C:\\steam\\Scripts\\depot_"+ build_string + "_64" + ".vdf", "w") as depot_file:
    depot_file.write(depot64_config.format(build_string=build_string, hash=hash))

with open("C:\\steam\\Scripts\\" + build_string + ".vdf", "w") as app_file:
    app_file.write(app_config.format(build_string=build_string, hash=hash))

s = "C:\\steam\\Scripts\\{build_string}.vdf".format(build_string=build_string)
a = ["C:\\steam\\tools\\ContentBuilder\\builder\\steamcmd.exe", '+login', 'gridirondev', 'v5DMB5LtR2q8Lpq', '+run_app_build_http', s, "+quit"]


subprocess.call(a)
