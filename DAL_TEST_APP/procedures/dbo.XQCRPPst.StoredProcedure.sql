USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XQCRPPst]    Script Date: 12/21/2015 13:57:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[XQCRPPst] @RI_ID smallint 
AS

DELETE FROM XQCRP WHERE RI_ID = @RI_ID
GO
