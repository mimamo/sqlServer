USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcCustInv_delete]    Script Date: 12/21/2015 15:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcCustInv_delete] as
delete from xkcCustInv
GO
