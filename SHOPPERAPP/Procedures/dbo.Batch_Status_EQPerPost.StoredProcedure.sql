USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Status_EQPerPost]    Script Date: 12/21/2015 16:13:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Status_EQPerPost    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Status_EQPerPost] @parm1 varchar ( 1), @parm2 varchar ( 6) as
       Select * from Batch
           where Status   = @parm1
             and PerPost  = @parm2
       order by Status, Module, BatNbr
GO
