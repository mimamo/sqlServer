USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Update_INTran_PerPost]    Script Date: 12/21/2015 13:57:17 ******/
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
