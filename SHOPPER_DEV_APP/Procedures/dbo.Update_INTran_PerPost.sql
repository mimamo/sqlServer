USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Update_INTran_PerPost]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Update_INTran_PerPost] 
	@parm1 varchar (10),
	@parm2 varchar (6)
as
	Update INTran 
	Set PerPost = @parm2
	Where Batnbr = @parm1
GO
