USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Slsper_Name]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Slsper_Name] @parm1 Varchar(30) as
       Select Name from Salesperson where Slsperid = @Parm1
GO
