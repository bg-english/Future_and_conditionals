$shield = [IO.File]::ReadAllText("C:\BOSTON FLEX\PROJECT FUTURE CLASS 8TH GRADE\shield_clean.txt").Trim()
$judah  = [IO.File]::ReadAllText("C:\BOSTON FLEX\PROJECT FUTURE CLASS 8TH GRADE\judah_clean.txt").Trim()
$template = [IO.File]::ReadAllText("C:\BOSTON FLEX\PROJECT FUTURE CLASS 8TH GRADE\app_template.html")
$out = $template.Replace("__SHIELD_B64__", $shield).Replace("__JUDAH_B64__", $judah)
[IO.File]::WriteAllText("C:\BOSTON FLEX\PROJECT FUTURE CLASS 8TH GRADE\FutureLab_Unified.html", $out, [Text.Encoding]::UTF8)
Write-Host "Done! File written."
