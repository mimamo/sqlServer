USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAInventory_All]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAInventory_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSFAInventory WHERE BatId LIKE @parm1 AND DateCancel <= '01/01/1900' ORDER BY BatId
GO
