USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDROL_uus4]    Script Date: 12/21/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJPTDROL_uus4]
as
update PJPTDROL
set    com_amount = 0,
com_units  = 0
where com_amount <> 0 or com_units <> 0
GO
