USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xREAPCHK_delete]    Script Date: 12/21/2015 16:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xREAPCHK_delete]   as
delete from xREAPCHK
GO
