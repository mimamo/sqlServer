USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xaptranex_dbnav]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xaptranex_dbnav] 
	@parm1 Varchar (10)  	--Batch Number

As


Select * from xaptranex where Batnbrgl = '' and BatNbrap like @parm1
GO
