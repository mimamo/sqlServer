USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARAdjust_AdJd_Cust_Ref_Type2]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARAdjust_AdJd_Cust_Ref_Type2    Script Date: 4/7/98 12:30:32 PM ******/
Create proc [dbo].[ARAdjust_AdJd_Cust_Ref_Type2] @parm1 varchar ( 15), @parm2 varchar ( 10), @parm3 varchar ( 2) As
SELECT *
  FROM ARAdjust
 WHERE custid = @parm1 AND
       AdjdRefNbr = @parm2 AND
       AdjdDoctype = @parm3 AND
       NOT (AdjgDoctype = 'SB' AND AdjdDoctype = 'SC')
GO
