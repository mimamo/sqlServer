USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xaptranex_dbnav]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xaptranex_dbnav] 
	@parm1 Varchar (10)  	--Batch Number

As


Select * from xaptranex where Batnbrgl = '' and BatNbrap like @parm1
GO
