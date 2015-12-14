USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadProjectEstimates]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadProjectEstimates]
	(
	@ProjectKey int
	)
AS

select * from tEstimate (nolock) Where ProjectKey = @ProjectKey
Order By EstimateName, Revision
GO
