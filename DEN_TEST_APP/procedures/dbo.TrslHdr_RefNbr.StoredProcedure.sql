USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[TrslHdr_RefNbr]    Script Date: 12/21/2015 15:37:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TrslHdr_RefNbr    Script Date: 4/7/98 12:45:04 PM ******/
Create Proc [dbo].[TrslHdr_RefNbr] @parm1 varchar ( 10) AS
     Select * from FSTrslHd
          Where RefNbr like @parm1
          Order by RefNbr
GO
