USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xREAPCHK_delete]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xREAPCHK_delete]   as
delete from xREAPCHK
GO
