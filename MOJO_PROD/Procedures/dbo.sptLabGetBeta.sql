USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLabGetBeta]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLabGetBeta]
AS

SELECT
	*
FROM
	tLab
WHERE
	Beta = 1
GO
