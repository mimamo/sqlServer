USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XQCPRPst]    Script Date: 12/21/2015 13:45:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[XQCPRPst] @RI_ID smallint 
AS

DELETE FROM XQCPR WHERE RI_ID = @RI_ID
GO
