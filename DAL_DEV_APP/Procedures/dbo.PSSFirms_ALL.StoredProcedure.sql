USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFirms_ALL]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSFirms_ALL] @parm1 VARCHAR (10) AS
  SELECT * FROM PSSFirms WHERE FirmNo LIKE @parm1 ORDER BY FirmNo
GO
