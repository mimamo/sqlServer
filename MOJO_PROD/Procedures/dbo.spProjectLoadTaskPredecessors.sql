USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadTaskPredecessors]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadTaskPredecessors]
	(
	@ProjectKey int
	)
AS

select tp.* from tTaskPredecessor tp (nolock) 
Inner join tTask t (nolock) on tp.TaskKey = t.TaskKey
Where ProjectKey = @ProjectKey
GO
