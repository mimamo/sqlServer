USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CATran_Batch_Select]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CATran_Batch_Select    Script Date: 4/7/98 12:49:20 PM ******/
create Proc [dbo].[CATran_Batch_Select] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 varchar ( 10) as
  Select * from catran
  Where module = 'CA' and batnbr = @parm4 and cpnyid = @parm1 and bankacct = @parm2 and banksub = @parm3
GO
