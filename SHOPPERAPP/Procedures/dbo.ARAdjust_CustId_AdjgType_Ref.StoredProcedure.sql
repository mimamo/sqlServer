USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARAdjust_CustId_AdjgType_Ref]    Script Date: 12/21/2015 16:13:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARAdjust_CustId_AdjgType_Ref    Script Date: 4/7/98 12:30:32 PM ******/
CREATE PROC [dbo].[ARAdjust_CustId_AdjgType_Ref] @parm1 varchar ( 15), @parm2 varchar ( 2), @parm3 varchar ( 10) as
SELECT *
  FROM ARAdjust
 WHERE CustId = @parm1
   AND AdjgDocType = @parm2
   AND AdjgRefNbr = @parm3
 ORDER BY CustId, AdjgDocType,AdjgRefNbr
GO
