USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Slsper_Name]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Slsper_Name] @parm1 Varchar(30) as
       Select Name from Salesperson where Slsperid = @Parm1
GO
