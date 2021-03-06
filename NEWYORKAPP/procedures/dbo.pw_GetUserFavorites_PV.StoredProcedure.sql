USE [NEWYORKAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'pw_GetUserFavorites_PV'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[pw_GetUserFavorites_PV]
GO

-- =============================================
-- Author:		Kelly Johnson
-- Create date: Aug 31, 2006
-- Description:	This will return a users favorites.  It will only return active jobs
-- 
-- Changes:
--     Oct 25, 2007 - Kelly Johnson - removed wildcard search on T.UserID like '" + @ParmUser + "'
--	   Feb 2, 2016	- Michelle Morales - replaced old joins with ANSI-standard
-- =============================================
CREATE PROCEDURE  [dbo].[pw_GetUserFavorites_PV]

	@ParmUser varchar(10), @SortCol varchar(60)  AS

	DECLARE @ProjCaption char(16)

	Select @ProjCaption=ltrim(substring(control_data,2,16)) from PJContrl 
		where control_type = 'FK' and control_code = 'PROJECT'

	exec("

	Select '" + @ProjCaption + "'=rtrim(P.Project), 
		'Description'=P.Project_Desc, 
		'Client ID'=P.pm_id01, 
		'Client Name'=C.Name 
	from PJProj P
	left outer join CUSTOMER C 
		on P.pm_id01 = C.CustId
	inner join PJPROJEM E
		on P.project = E.project 
	inner join TimeCardFavorite T
		on rtrim(P.Project) = T.JobID
	where (E.employee = '" + @ParmUser + "' 
			or E.employee = '*')  
        and P.Status_PA = 'A' 
        and P.Status_LB = 'A'         		
		and T.UserID like '" + @ParmUser + "'
	Order by " + @SortCol  
	)
GO


---------------------------------------------
-- permissions
---------------------------------------------
grant execute on pw_GetUserFavorites_PV to BFGROUP
go

grant execute on pw_GetUserFavorites_PV to MSDSL
go

grant control on pw_GetUserFavorites_PV to MSDSL
go

grant execute on pw_GetUserFavorites_PV to MSDynamicsSL
go