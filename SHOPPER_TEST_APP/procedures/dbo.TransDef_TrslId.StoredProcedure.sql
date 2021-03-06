USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[TransDef_TrslId]    Script Date: 12/21/2015 16:07:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TransDef_TrslId    Script Date: 4/7/98 12:45:04 PM ******/
Create Proc [dbo].[TransDef_TrslId] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 24), @parm4 varchar ( 10), @parm5 varchar ( 24) AS
     Select * From FSDefDet
          Where TrslId = @parm1
          and   BegAcctRange like @parm2
          and   BegSubRange  like @parm3
          and   EndAcctRange like @parm4
          and   EndSubRange  like @parm5
          Order by TrslId, BegAcctRange, BegSubRange, EndAcctRange, EndSubRange
GO
