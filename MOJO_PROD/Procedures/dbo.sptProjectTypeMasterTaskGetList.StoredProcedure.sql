USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeMasterTaskGetList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeMasterTaskGetList]

	(
		@ProjectTypeKey int
	)

AS --Encrypt
	Select
		mt.*
		,ISNULL(mt.TaskID, '') + ' - ' + ISNULL(mt.TaskName, '') as FullName  
	From
		tMasterTask mt (nolock) 
		Inner join tProjectTypeMasterTask ptmt (nolock) on ptmt.MasterTaskKey = mt.MasterTaskKey
	Where
		ptmt.ProjectTypeKey = @ProjectTypeKey
	Order By ptmt.DisplayOrder
GO
