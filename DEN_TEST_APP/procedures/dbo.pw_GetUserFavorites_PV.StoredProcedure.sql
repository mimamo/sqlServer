USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pw_GetUserFavorites_PV]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Kelly Johnson
-- Create date: Aug 31, 2006
-- Description:	This will return a users favorites.  It will only return active jobs
-- 
-- Changes:
--     Oct 25, 2007 - Kelly Johnson - removed wildcard search on T.UserID like '" + @ParmUser + "'
-- =============================================
CREATE PROCEDURE  [dbo].[pw_GetUserFavorites_PV]

	@ParmUser varchar(10), @SortCol varchar(60)  AS

	DECLARE @ProjCaption char(16)

	Select @ProjCaption=ltrim(substring(control_data,2,16)) from PJContrl 
		where control_type = 'FK' and control_code = 'PROJECT'

	exec("

	Select '" + @ProjCaption + "'=rtrim(P.Project), 'Description'=P.Project_Desc, 'Client ID'=P.pm_id01, 'Client Name'=C.Name 
	from PJProj P, CUSTOMER C, PJPROJEM E, TimeCardFavorite T
	where   
        P.project = E.project and 
        (E.employee = '" + @ParmUser + "' or E.employee = '*')  
        and P.Status_PA = 'A' and P.Status_LB = 'A' and P.pm_id01 *= C.CustId
		and rtrim(P.Project) = T.JobID
		and T.UserID like '" + @ParmUser + "'
	Order by " + @SortCol  
	)
GO
