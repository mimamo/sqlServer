USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Select]    Script Date: 12/21/2015 16:13:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Select    Script Date: 4/7/98 12:49:19 PM ******/
create Proc [dbo].[ARDoc_Select] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 varchar ( 10) as
  Select * from ardoc
  Where cpnyid = @parm1
and bankacct = @parm2
and banksub = @parm3
and batnbr = @parm4
and rlsed = 1
GO
