USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10590]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10590]

AS
	SET NOCOUNT ON
	
	-- seed DisplayOnDashboard and UseDefaultProbability for Lead Stage
	update tLeadStage set DisplayOnDashboard = 1


	update tLeadStage set UseDefaultProbability = 1
	where ISNULL(DefaultProbability, 0) > 0


	update tLeadStage set UseDefaultProbability = 0
	where ISNULL(DefaultProbability, 0) = 0
GO
