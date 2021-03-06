USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptMasterTaskGetLookup]    Script Date: 12/10/2015 12:30:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptMasterTaskGetLookup]

	(
		@CompanyKey int,
		@TaskID varchar(50)
	)

AS --Encrypt

if @TaskID is null
	Select
		MasterTaskKey,
		TaskID,
		TaskName,
		TaskID + ' - ' + TaskName as FullName
	From tMasterTask (nolock)
	Where
		CompanyKey = @CompanyKey and
		Active = 1 and
		TaskType = 1
	Order By TaskID
else
	Select
		MasterTaskKey,
		TaskID,
		TaskName,
		TaskID + ' - ' + TaskName as FullName
	From tMasterTask (nolock)
	Where
		CompanyKey = @CompanyKey and
		TaskID like @TaskID + '%' and
		Active = 1 and
		TaskType = 1
	Order By TaskID
GO
