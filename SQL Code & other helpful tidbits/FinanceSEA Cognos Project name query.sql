select project, project_desc, ltrim(rtrim(project)) + ' - ' + ltrim(rtrim(project_desc)) as 'title' from PJPROJ where project in ('05176313SEA'
,'05176513SEA','05176613SEA','05176413SEA',
'05177213SEA','05177313SEA','05181013SEA','05176713SEA','05176813SEA','05176913SEA','05177013SEA','05177113SEA')