USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xPA940Pst]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xPA940Pst] @RI_ID smallint 
AS

DELETE FROM xPA940 WHERE RI_ID = @RI_ID
GO
