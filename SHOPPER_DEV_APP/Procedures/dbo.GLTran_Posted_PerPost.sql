USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLTran_Posted_PerPost]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GLTran_Posted_PerPost    Script Date: 4/7/98 12:38:59 PM ******/
Create Proc [dbo].[GLTran_Posted_PerPost] @parm1 varchar ( 1), @parm2 varchar ( 6) as
       Select * from GLTran
           where Posted             =  @parm1
             and PerPost  Like         @parm2
           order by Posted, Acct, Sub, PerPost
GO
