USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAInventory_Nav]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAInventory_Nav] @parm1 VARCHAR(10), @parm2min SMALLINT, @parm2max SMALLINT AS
  SELECT * FROM PSSFAInventory WHERE BatId = @parm1 AND LineId BETWEEN @parm2min AND @parm2max AND DateCancel <= '01/01/1900' ORDER BY BatId
GO
