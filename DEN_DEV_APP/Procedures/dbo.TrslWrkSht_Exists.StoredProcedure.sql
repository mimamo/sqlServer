USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TrslWrkSht_Exists]    Script Date: 12/21/2015 14:06:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TrslWrkSht_Exists    Script Date: 4/7/98 12:45:04 PM ******/
Create Proc [dbo].[TrslWrkSht_Exists] @parm1 varchar ( 10), @parm2 varchar ( 6) AS
     Select * from FSTrslHd
          Where TrslId  = @parm1
          and   PerPost like @parm2
          Order by TrslId DESC, PerPost DESC, RefNbr DESC
GO
