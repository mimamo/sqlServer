USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_Pidetail_OR]    Script Date: 12/21/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_Pidetail_OR    Script Date: 4/17/98 10:58:17 AM ******/
Create Proc [dbo].[Delete_Pidetail_OR] @Parm1 Varchar(10) as
	Delete From PIDetail Where PIID = @Parm1
GO
