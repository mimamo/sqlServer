USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetUpdateHistory]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetUpdateHistory]
	(
	@ActivityKey int
	)

AS

Select FirstName + ' ' + LastName as UserName,
	ActivityDate,
	Notes
From tActivityHistory ah (nolock)
	inner join tUser u (nolock) on ah.UserKey = u.UserKey
Where ah.ActivityKey = @ActivityKey
Order By ActivityDate DESC
GO
