USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARRev_Invbnbr]    Script Date: 12/21/2015 14:17:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARRev_Invbnbr    Script Date: 4/7/98 12:30:33 PM ******/
CREATE PROC [dbo].[ARRev_Invbnbr] @parm1 varchar(10) AS
SELECT *
  FROM ARAdjust
 WHERE adjdrefnbr = @parm1
   AND AdjdDoctype IN ('IN','DM','FI','NC')
ORDER BY AdjdRefnbr
GO
