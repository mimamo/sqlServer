USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_uus4]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJPTDSUM_uus4]
as
update PJPTDSUM
set    com_amount = 0,
com_units  = 0
where com_amount <> 0 or com_units <> 0
GO
