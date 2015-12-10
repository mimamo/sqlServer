USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10591]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10591]

AS
	SET NOCOUNT ON
	
	-- (252676) Set Project Active flags to 1 or 0 based on their Project Status settings
	Update p
	   set p.Active = 1
	 from tProject p INNER JOIN tProjectStatus ps (nolock) ON (ps.ProjectStatusKey = p.ProjectStatusKey and
													           ps.IsActive = 1)
	Where p.Active = 0
	  and p.Closed = 0
	--
	Update p
	   set p.Active = 0
	 from tProject p INNER JOIN tProjectStatus ps (nolock) ON (ps.ProjectStatusKey = p.ProjectStatusKey and
													           ps.IsActive = 0)
	Where p.Active = 1
	  and p.Closed = 0
GO
