USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Update_AssyDoc_PerPost]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Update_AssyDoc_PerPost] 
	@parm1 varchar (10),
	@parm2 varchar (6)
as
	Update AssyDoc
	Set PerPost = @parm2
    Where BatNbr = @parm1
GO
