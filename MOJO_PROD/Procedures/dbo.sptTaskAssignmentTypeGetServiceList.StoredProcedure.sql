USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskAssignmentTypeGetServiceList]    Script Date: 12/10/2015 12:30:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskAssignmentTypeGetServiceList]
	(
		@TaskAssignmentTypeKey int,
		@CompanyKey int
	)
AS --Encrypt


Select
	s.ServiceKey,
	s.Description,
	ISNULL(tat.Used, 0) as Used,
	ISNULL(tat.Notify, 0) as Notify
From
	tService s (nolock) 
	left outer join (Select ServiceKey, Used, Notify from tTaskAssignmentTypeService (NOLOCK) Where TaskAssignmentTypeKey = @TaskAssignmentTypeKey) as tat
	on s.ServiceKey = tat.ServiceKey
Where
	s.CompanyKey = @CompanyKey and s.Active = 1
Order By s.Description
GO
