USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TrnsfrDoc_BatNbr]    Script Date: 12/21/2015 14:18:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TrnsfrDoc_BatNbr    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.TrnsfrDoc_BatNbr    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[TrnsfrDoc_BatNbr] @parm1 varchar ( 10), @parm2 varchar ( 10) as
    Select * from TrnsfrDoc
           where BatNbr = @parm1
GO
